/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import qGNA.Library 1.0

import "." as Blocks
import "GameSwitch" as GameSwitch
import "../Elements" as Elements
import "../Models" as Models
import "../js/Core.js" as Core
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../Blocks/Features/Maintenance/MaintenanceHelper.js" as MaintenanceHelper
import "../js/GamesSwitchHelper.js" as GamesSwitchHelper

Item {
    id: root

    width: Core.clientWidth
    height: Core.clientHeight

    property string labelImage

    property int lastGameIndex : -1
    property int currentIndex : -1
    property variant currentItem: Core.currentGame()

    property color infoTextColor: "#FFFFFF"
    property QtObject currentBigButton;
    property QtObject currentTextDownload;

    property int animationType: 0       // 0 - scale back image, 1 - back image move to left, 2 - back image move to right
    signal finishAnimation();
    signal gameSelection(variant item);

    property int lastVisibleGameIndex : -1

    property bool _maintenance: false

    function gamesButtonClicked(item) {
        if (currentItem == item || switchAnimation.running )
            return;

        gameSelection(item);
        Core.activateGame(item);
    }

    function isServiceInstalled(serviceId) {
        return (1 == Settings.value("GameDownloader/" + serviceId + "/", "isInstalled", 0));
    }

    onVisibleChanged: {
        if (!visible) {
            lastVisibleGameIndex = currentIndex;
            currentIndex = -1;
        } else {
            if (lastVisibleGameIndex != -1 && currentIndex == -1)
                currentIndex = lastVisibleGameIndex
            else
                currentIndex = currentItem ? Core.indexByServiceId(currentItem.serviceId) : -1;
        }
    }

    onCurrentIndexChanged: {
        buttonsBlock.visible = false;
        serviceStatusText.opacity = 0;
        newsBlock.visible = false;

        if (currentIndex == -1) {
            lastGameIndex = -1;
            return;
        }

        if (lastGameIndex != -1) {
            var lastItem = Core.serviceItemByIndex(lastGameIndex);
            if (lastItem) {
                backgroundImage2.source = installPath + lastItem.imageBack
            }
        }

        if (lastGameIndex == -1) {
            animationType = 0;
        } else if (lastGameIndex === (Core.count - 1) && currentIndex === 0) {
            backgroundImage.x = Core.clientWidth;
            animationType = 2;
        } else if (currentIndex < lastGameIndex) {
            backgroundImage.x = -Core.clientWidth;
            animationType = 1;
        } else {
            backgroundImage.x = Core.clientWidth;
            animationType = 2;
        }

        backgroundImage.scale = 1;
        serviceStatusText.opacity = 1;
        switchAnimation.start();
        lastGameIndex = currentIndex;
    }

    onCurrentItemChanged: {
        newsBlock.visible = false;

        if (!currentItem) {
            currentIndex = -1
            return;
        }

        currentIndex = Core.indexByServiceId(currentItem.serviceId);

        d.ignoreMaintenance = false;
        d.updateMaintenance();

        downloadIcon.update();
        processWidget.refresh();
    }

    QtObject {
        id: d

        function updateMaintenance() {
            if (d.ignoreMaintenance) {
                return;
            }

            if (!MaintenanceHelper.updatedService.hasOwnProperty(currentItem.serviceId)) {
                root._maintenance = false;
                return;
            }

            root._maintenance = isServiceMaintenance(currentItem.serviceId);
        }

        function isServiceMaintenance(serviceId) {
            var item = Core.serviceItemByServiceId(serviceId);

            return item ? (item.maintenance &&
                           item.status === 'Normal' &&
                           (item.allreadyDownloaded ||
                            1 == Settings.value("GameDownloader/" + serviceId + "/",
                                                "isInstalled", 0)))
                        : false
        }

        property bool currentItemMaintenance: currentItem ? isServiceMaintenance(currentItem.serviceId) : false
        property bool ignoreMaintenance: false

        onCurrentItemMaintenanceChanged: updateMaintenance();
    }

    Connections {       
        target: mainWindow

        onDownloadButtonStartSignal: {
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            gamesButtonClicked(item);
            item.status = "Downloading";
        }

        onServiceStarted: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Started";
            item.statusText = qsTr("TEXT_PROGRESSBAR_NOW_PLAYING_STATE")
            console.log("onServiceStarted " + service)

            if (root.currentItem) {
                GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                           'Game ' + root.currentItem.gaName, 'Started');
            }

            announcementsFeature.gameStartedCallback(service);
        }

        onServiceFinished: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Finished"; //(Может и ошибку надо выставлять в случаи не успех)
            item.statusText = ""
            console.log("onServiceFinished " + service + " with state " + serviceState)

            announcementsFeature.gameClosedCallback();
        }

        onDownloaderStarted: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Downloading";
            item.allreadyDownloaded = false;

            GamesSwitchHelper.gamesDownloadData[service] = {};
            downloadIcon.update();
            console.log("START DOWNLOAD");
        }

        onDownloaderStopped: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Paused";
            console.log("DOWNLOAD STOPPED");
        }

        onDownloaderStopping: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Paused";
            console.log("DOWNLOAD STOPPING");
        }

        onDownloaderFailed: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Error";
            item.statusText = "";
            console.log("DOWNLOAD FAILED");
        }

        onDownloaderFinished: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.progress = 100;
            item.allreadyDownloaded = true;
            item.status = "Normal";
            item.statusText = qsTr("TEXT_PROGRESSBAR_DOWNLOADED_AND_READY_STATE")
            console.log("DOWNLOAD FINISHED");

            MaintenanceHelper.updatedService[service] = true;
            d.updateMaintenance();

            if (!root._maintenance) {
                mainWindow.executeService(service);
            }
        }

        onProgressbarChange:
        {
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            var isInstalled = root.isServiceInstalled(serviceId);

            if (totalWanted > 0) {
                GamesSwitchHelper.gamesDownloadData[serviceId] = {
                    totalWantedDone: totalWantedDone,
                    totalWanted: totalWanted,
                    directTotalDownload: directTotalDownload,
                    peerTotalDownload: peerTotalDownload,
                    payloadTotalDownload: payloadTotalDownload,
                    peerPayloadDownloadRate: peerPayloadDownloadRate,
                    payloadDownloadRate: payloadDownloadRate,
                    directPayloadDownloadRate: directPayloadDownloadRate,
                    playloadUploadRate: playloadUploadRate,
                    totalPayloadUpload: totalPayloadUpload
                }

                processWidget.refresh();
            }

            item.progress = progress;
            if (totalWantedDone >= 0) {
                item.statusText = (isInstalled ? qsTr("TEXT_PROGRESSBAR_UPDATING_NOW_STATE") :
                                                 qsTr("TEXT_PROGRESSBAR_DOWNLOADING_NOW_STATE"))
                .arg(Math.round(totalWantedDone / 10000) / 100)
                .arg(Math.round(totalWanted / 10000) / 100)
            }
        }

        onProgressbarExtractionChange:
        {
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            item.progress = progress
            if (totalWantedDone >= 0) {
                item.statusText = qsTr("TEXT_PROGRESSBAR_EXTRACTING_NOW_STATE").arg(totalWantedDone).arg(totalWanted)
            }
        }

        onDownloaderServiceStatusMessageChanged: {
            console.log('onDownloaderServiceStatusMessageChanged ' + service + ' message ' + message)
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('onDownloaderServiceStatusMessageChanged item not found ' + service)
                return;
            }

            item.statusText = message;
        }

    }

    SequentialAnimation {
        id: switchAnimation

        running: false;
        onStarted: newsBlock.reloadNews();

        ParallelAnimation {
            NumberAnimation {
                target: backgroundImage;
                easing.type: Easing.OutQuad;
                property: animationType == 0 ? "scale" : "x";
                from: animationType == 0 ? 0.7 : animationType == 1 ? -Core.clientWidth : Core.clientWidth;
                to: animationType == 0 ? 1 : 0;
                duration: 150
            }

            NumberAnimation {
                target: backgroundImage2;
                property: "x";
                from: 0
                to: animationType == 1 ? Core.clientWidth : -Core.clientWidth;
                duration: 150
            }

            SequentialAnimation {

                PauseAnimation { duration: 300 }

                PropertyAnimation {
                    target: buttonsBlock;
                    easing.type: Easing.OutQuad;
                    property: "visible";
                    to: true;
                }

                NumberAnimation {
                    target: singleBigButton;
                    easing.type: Easing.OutQuad;
                    property: "anchors.rightMargin";
                    from: -200;
                    to: 35;
                    duration: 150
                }

                ScriptAction {
                    script: buttonsBlock.focus = true
                }
            }
        }
    }

    Rectangle {
        color: "#000000"
        anchors.fill: parent

        Image {
            id: backgroundImage
            source: currentItem ? installPath + currentItem.imageBack : ""
            scale: 1
        }

        Image {
            id: backgroundImage2
            scale: 1
            visible: animationType > 0
        }
    }

    Elements.IconButton {
        toolTip: qsTr('REWARDS_TOOLTIP')
        text: qsTr('REWARDS_BUTTON')
        source: installPath + "images/menu/Rewards.png"
        anchors { top: parent.top; right: parent.right }
        anchors { topMargin: 99; rightMargin: 33 }
        onClicked: mainAuthModule.openWebPage("http://www.gamenet.ru/");
    }

    Image {
        source: installPath + "images/rightArrow.png"
        opacity: rightArrowImageMouseArea.containsMouse ? 1 : 0.5
        visible: false
        anchors { top: parent.top; right: parent.right }
        anchors { topMargin: 150; rightMargin: 10 }

        Elements.CursorMouseArea {
            id: rightArrowImageMouseArea

            anchors.fill: parent
            onClicked: {
                var nextIndex = currentIndex >= (Core.count - 1) ? 0 : currentIndex + 1;
                var item = Core.serviceItemByIndex(nextIndex);

                if (root.currentItem) {
                    GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                               'Navigation', 'Switch To Game ' + item.gaName, 'Arrow');
                }

                gamesButtonClicked(item);
            }
        }
    }

    Item {
        anchors.fill: parent
        visible: !_maintenance

        Blocks.NewsBlock {
            id: newsBlock

            anchors { top: parent.top; left: parent.left }
            anchors { topMargin: 97; leftMargin: 30 }
            visible: false
            filterGameId: currentItem ? currentItem.gameId : "671"

            SequentialAnimation {
                id: newsAnimation

                PauseAnimation { duration: 300 }
                PropertyAnimation {
                    target: newsBlock;
                    easing.type: Easing.OutQuad;
                    property: "visible";
                    to: true;
                }

                NumberAnimation {
                    target: newsBlock;
                    easing.type: Easing.OutQuad;
                    property: "anchors.leftMargin";
                    from: -350;
                    to: 30;
                    duration: 150
                }
            }

            onNewsReady: newsAnimation.start();
        }
    }

    Rectangle {
        color: "#000000"
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors { bottomMargin: 52 }
        height: 108
        opacity: 0.45
    }

    GameSwitch.Maintenance {
        visible: _maintenance

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        anchors { bottomMargin: 52 }

        currentItem: parent.currentItem
        onLaunchGame: {
            var item = Core.serviceItemByServiceId(serviceId);
            mainWindow.downloadButtonStart(serviceId);
            gamesButtonClicked(item)
            GoogleAnalytics.trackEvent('/game/' + item.gaName,
                                       'Game ' + item.gaName, 'Play', 'Maintenance');
        }
    }

    Item {
        id: buttonsBlock

        visible: false
        anchors { bottom: parent.bottom; right: parent.right; bottomMargin: 25; }

        Keys.onPressed:  {
            if ((event.key === Qt.Key_M)
                    && (event.modifiers & Qt.ShiftModifier)
                    && (event.modifiers & Qt.ControlModifier)
                    ) {
                root._maintenance = false;
                d.ignoreMaintenance = true;
            }
        }

        Elements.ButtonBig {
            id: singleBigButton

            visible: !_maintenance

            anchors { bottom: parent.bottom; right: parent.right; bottomMargin: 65; rightMargin: 35 }

            buttonText: qsTr("BUTTON_PLAY_DEFAULT_STATE")
            buttonPauseText: qsTr("BUTTON_PLAY_ON_PAUSE_STATE")
            buttonDownloadText: qsTr("BUTTON_PLAY_DOWNLOADING_NOW_STATE")
            buttonErrorText: qsTr("BUTTON_PLAY_ERROR_STATE")
            buttonDownloadedText: qsTr("BUTTON_PLAY_DOWNLOADED_AND_READY_STATE")

            isMouseAreaAccepted: qGNA_main.isPageControlAccepted

            startDownloading: currentItem ? currentItem.status === "Downloading" : false
            isError: currentItem ? currentItem.status === "Error" : false
            isPause: currentItem ? currentItem.status === "Paused" : false
            isStarted: currentItem ? currentItem.status === "Started" : false

            progressPercent: currentItem ? currentItem.progress : -1

            onButtonClicked: {
                if (!currentItem) {
                    return;
                }

                var status = currentItem.status,
                        serviceId = currentItem.serviceId;

                if (status === "Downloading") {
                    mainWindow.downloadButtonPause(serviceId);
                    if (root.currentItem) {
                        GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                                   'Game ' + root.currentItem.gaName, 'Pause', 'Big Green');
                    }
                } else {
                    mainWindow.downloadButtonStart(serviceId);
                    if (root.currentItem) {
                        GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                                   'Game ' + root.currentItem.gaName, 'Play', 'Big Green');
                    }
                }
            }
        }
    }

    Blocks.GamesSwitchFooter {
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        anchors { bottomMargin: 32 }
        currentGameItem: root.currentItem
        width: parent.width;

        onItemClicked: {
            if (root.currentItem) {
                GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                           'Navigation', 'Switch To Game ' + item.gaName, 'Pin');
            }

            gamesButtonClicked(item);
        }
    }

    Text {
        id: serviceStatusText

        visible: !root._maintenance
        text: currentItem ? currentItem.statusText : ""

        anchors { left: parent.left; bottom: parent.bottom; leftMargin: 31; bottomMargin: 80 }
        font { family: "Segoe UI Light"; bold: false; pixelSize: 24; weight: "Light" }
        color: infoTextColor
        smooth: true
    }

    ProgressWidget {
        id: processWidget

        anchors { left: parent.left; bottom: parent.bottom; leftMargin: 8; bottomMargin: 72 }
        visible: false

        function refresh() {
            totalWantedDone = progressValue('totalWantedDone')
            totalWanted =  progressValue('totalWanted')
            directTotalDownload = progressValue('directTotalDownload')
            peerTotalDownload = progressValue('peerTotalDownload')
            payloadTotalDownload = progressValue('payloadTotalDownload')
            peerPayloadDownloadRate = progressValue('peerPayloadDownloadRate')
            payloadDownloadRate = progressValue('payloadDownloadRate')
            directPayloadDownloadRate = progressValue('directPayloadDownloadRate')
            playloadUploadRate = progressValue('playloadUploadRate')
            totalPayloadUpload = progressValue('totalPayloadUpload')
        }

        function progressValue(arg) {
            if (!currentItem ||
                !GamesSwitchHelper.gamesDownloadData.hasOwnProperty(currentItem.serviceId)) {
                return '0';
            }

            var item = GamesSwitchHelper.gamesDownloadData[currentItem.serviceId][arg];

            return item ? (item >= 0 ? item : '0') : '0'
        }

        //HACK Using mainWindow, mainWindowRectanglw in Block. But there is no any other ways to make QGNA-60
        Connections {
            target: mainWindow
            onLeftMouseClick: {
                if (!processWidget.visible || downloadIcon.containsMouse)
                    return;

                var posInWidget = processWidget.mapToItem(mainWindowRectanglw, mainWindowRectanglw.x, mainWindowRectanglw.y);
                if (globalX >= posInWidget.x
                    && globalX <= posInWidget.x + processWidget.width
                    && globalY >= posInWidget.y
                    && globalY <= posInWidget.y + processWidget.height)
                    return;

                processWidget.visible = false;
            }
        }

        MouseArea { // Отключаем фоновые клики
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    Elements.ImageButton {
        id: downloadIcon

        function update() {
            opacity = currentItem ? GamesSwitchHelper.gamesDownloadData.hasOwnProperty(currentItem.serviceId) : false;
        }

        opacity: 0
        width: 10
        height: 10
        source: installPath + 'images/downloadInfo.png'
        anchors { left: parent.left; bottom: parent.bottom; leftMargin: 17; bottomMargin: 56 }
        onClicked: {
            processWidget.visible = !processWidget.visible;

            if (root.currentItem) {
                GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                           'Game ' + root.currentItem.gaName, 'Open torrent stat', 'Small info button');
            }
        }

        Behavior on opacity {
            PropertyAnimation { duration: 200 }
        }
    }
}
