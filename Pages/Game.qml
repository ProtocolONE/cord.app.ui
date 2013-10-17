import QtQuick 1.1
import Tulip 1.0

import "../Elements" as Elements
import "../Blocks" as Blocks
import "../Blocks/GameSwitch" as GameSwitch

import "../js/Core.js" as Core
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../js/PopupHelper.js" as PopupHelper
import "../js/GamesSwitchHelper.js" as GamesSwitchHelper
import "../Features/Maintenance/MaintenanceHelper.js" as MaintenanceHelper
import "../Features/Facts" as Feature
import "../Proxy/App.js" as App
import "../Proxy/MouseClick.js" as MouseClick
import "../js/Message.js" as AlertMessage

import "../Features/PublicTest/index.js" as PublicTest

Rectangle {
    id: root

    width: Core.clientWidth
    height: Core.clientHeight

    function activateNews(force) {
        newsBlock.forceShowNews = force;
    }

    /* HACK
    color: "black"
    Component.onCompleted: Core.activateGameByServiceId("300003010000000000")
    */

    property variant currentItem: Core.currentGame()

    signal gameSelection(variant item);

    // UNDONE Убрать это отсюда можно и завязать все на JS и сигнал оттуда
    function gamesButtonClicked(item) {
        if (currentItem == item)
            return;

        gameSelection(item);
        Core.activateGame(item);
    }

    function showPopupGameInstalled(serviceId) {
        var gameItem = Core.serviceItemByServiceId(serviceId)
            , popUpOptions;

        popUpOptions = {
            gameItem: gameItem,
            buttonCaption: qsTr('POPUP_PLAY'),
            message: qsTr('POPUP_READY_TO_START')
        };

        PopupHelper.showPopup(gameInstalledPopUp, popUpOptions, 'gameInstalled' + serviceId);
        GoogleAnalytics.trackEvent('/announcement/gameInstalled/' + gameItem.serviceId,
                                   'Announcement', 'Show Announcement', gameItem.gaName);
    }

    onCurrentItemChanged: {
        if (!currentItem) {
            return;
        }

        processWidget.visible = false;
        d.ignoreMaintenance = false;
        d.updateMaintenance();

        downloadIcon.update();
        processWidget.refresh();

        frontImage.source = Core.previousGame() ? installPath + Core.previousGame().imageBack : ""
        backImage.source = currentItem ? installPath + currentItem.imageBack : ""

        changeGameAnim.start();
    }

    Component {
        id: gameInstalledPopUp

        Elements.GameItemPopUp {
            id: popUp

            function gaEvent(name) {
                GoogleAnalytics.trackEvent('/announcement/gameInstalled/' + gameItem.serviceId,
                                           'Announcement', name, gameItem.gaName);
            }

            Connections {
                target: mainWindow
                onServiceStarted: {
                    if (gameItem.serviceId == service) {
                        shadowDestroy();
                    }
                }
            }

            state: "Green"
            onAnywhereClicked: gaEvent('Miss Click On Announcement')
            onCloseButtonClicked: gaEvent('Close Announcement')
            onPlayClicked: {
                gaEvent('Action on Announcement');
                Core.activateGame(gameItem);
                App.executeService(gameItem.serviceId);
            }
        }
    }

    ParallelAnimation {
        id: changeGameAnim

        PropertyAnimation {
            target: frontImage;
            easing.type: Easing.Linear;
            property: "opacity";
            from: 1;
            to: 0;
            duration: 500
        }
    }

    QtObject {
        id: d

        function updateMaintenance() {
            if (d.ignoreMaintenance) {
                return;
            }

            d._maintenanceEndPause = !!currentItem.maintenanceEndPause;

            if (!MaintenanceHelper.updatedService.hasOwnProperty(currentItem.serviceId)) {
                d._maintenance = false;
                return;
            }

            d._maintenance = isServiceMaintenance(currentItem.serviceId);
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

        function isServiceInstalled(serviceId) {
            return (1 == Settings.value("GameDownloader/" + serviceId + "/", "isInstalled", 0));
        }

        property bool _maintenance: false
        property bool _maintenanceEndPause: false

        property bool currentItemMaintenance: currentItem ? isServiceMaintenance(currentItem.serviceId) : false
        property bool ignoreMaintenance: false

        onCurrentItemMaintenanceChanged: updateMaintenance();
    }

    Timer {
        id: activateWindowTimer

        interval: 1000
        running: false

        onTriggered: App.activateWindow();
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
            console.log("onServiceStarted " + service);

            Core.runningService[service] = 1;

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
            console.log("onServiceFinished " + service + " with state " + serviceState);

            delete Core.runningService[service];

            if (item.gameType != 'browser') {
                activateWindowTimer.start();
            }

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

            if (d._maintenance) {
                return;
            }

            var isPopUpCase = (App.isWindowVisible() && Core.currentGame() !== item); //QGNA-378
            if (isPopUpCase) {
                showPopupGameInstalled(service);
            } else {
                App.executeService(service);
            }
        }

        onProgressbarChange: { // @DEPRECATED
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            var isInstalled = d.isServiceInstalled(serviceId);

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

        onTotalProgressChanged: {
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            item.progress = progress;
        }

        onDownloadProgressChanged: {
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            var isInstalled = d.isServiceInstalled(serviceId);
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

            item.progress = progress;
            item.statusText = (isInstalled ? qsTr("TEXT_PROGRESSBAR_UPDATING_NOW_STATE") :
                                             qsTr("TEXT_PROGRESSBAR_DOWNLOADING_NOW_STATE"))
                .arg(Math.round(totalWantedDone / 10000) / 100)
                .arg(Math.round(totalWanted / 10000) / 100);
        }

        onProgressbarExtractionChange: {// @DEPRECATED
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

    Row {
        anchors.fill: parent

        Item {
            width: 114
            anchors { top: parent.top; bottom: parent.bottom }

            Blocks.GamesSwitchFooter {
                anchors.fill: parent
                currentGameItem: root.currentItem

                onItemClicked: {
                    if (root.currentItem) {
                        GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                                   'Navigation', 'Switch To Game ' + item.gaName, 'Pin');
                    }

                    gamesButtonClicked(item);
                }
            }
        }

        Item {
            width: 816
            anchors { top: parent.top; bottom: parent.bottom }

            Image {
                id: backImage

                scale: 1
            }

            Image {
                id: frontImage

                scale: 1
            }

            Rectangle {
                color: "#ffffff"
                height: parent.height
                width: 1
                anchors.left: parent.left
                opacity: 0.15
            }

            Item {

                anchors { fill: parent; leftMargin: 1 }

                Blocks.Header { //86
                    anchors { left: parent.left; right: parent.right; top: parent.top }

                    onHomeButtonClicked: {
                        var currentGame = Core.currentGame();
                        if (currentGame) {
                            GoogleAnalytics.trackEvent('/game/' + currentGame.gaName,
                                                       'Navigation', 'Switch To Home', 'Header');
                        }

                        Core.activateGame(null);
                        qGNA_main.state = "HomePage";
                    }
                }

                Item {
                    anchors {
                        fill: parent
                        topMargin: 86
                        bottomMargin: 86
                    }

                    Elements.IconButton { //rewards
                        toolTip: qsTr('REWARDS_TOOLTIP')
                        text: qsTr('REWARDS_BUTTON')
                        source: installPath + "images/menu/Rewards.png"
                        anchors { top: parent.top; right: parent.right }
                        anchors { topMargin: 13; rightMargin: 30 }
                        tooltipGlueCenter: true
                        onClicked: mainAuthModule.openWebPage("http://rewards.gamenet.ru/");
                    }

                    Blocks.NewsBlock {
                        id: newsBlock

                        anchors { top: parent.top; left: parent.left }
                        anchors { topMargin: 11; leftMargin: 30 }
                        filterGameId: currentItem ? currentItem.gameId : "671"
                    }

                    Image {
                        visible: settingsViewModel.isPublicTestVersion

                        source: installPath + "/images/warning.png"
                        anchors { bottom: parent.bottom; right: parent.right }
                        anchors { bottomMargin: 130; rightMargin: 30 }

                        Elements.CursorMouseArea {
                            id: warningButtonMouser

                            anchors.fill: parent
                            hoverEnabled: true
                            toolTip: qsTr("PUBLIC_TEST_TOOLTIP")
                            onClicked: PublicTest.show();
                        }
                    }

                    Blocks.SocialNet {
                        anchors { bottom: parent.bottom; right: parent.right }
                        anchors { bottomMargin: 20; rightMargin: 30 }
                    }


                    Feature.Facts {
                        visible: (!d._maintenance) && (!d._maintenanceEndPause)
                        anchors { bottom: parent.bottom; left: parent.left }
                        anchors { bottomMargin: 20; leftMargin: 30 }
                    }

                    Rectangle {
                        anchors { bottom: parent.bottom; left: parent.left }
                        anchors { bottomMargin: 20; leftMargin: 30 }
                        visible: root.currentItem ? root.currentItem.gameId == 760 : false

                        width: 345
                        height: 85
                        color: "#ffff33"

                        Text {
                            font { family: 'Arial'; pixelSize: 21 }
                            color: '#111103'

                            anchors  { left: parent.left; top: parent.top; leftMargin: 25; topMargin: 9 }
                            text: qsTr("REBORB_ZBT_INVITE_HELPER_TEXT")
                        }

                        Elements.Button {
                            width: 146
                            height: 25

                            text: qsTr("REBORB_ZBT_INVITE_BUTTON_TEXT")
                            color: '#00000000'
                            border.color: "#111103"
                            textColor: "#111103"
                            font { pixelSize: 12; bold: true }

                            anchors  {
                                bottom: parent.bottom;
                                bottomMargin: 14;
                                horizontalCenter: parent.horizontalCenter;
                            }

                            onClicked: App.openExternalBrowser("http://www.reborngame.ru/");
                        }
                    }
                }

                Item {
                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                    height: 86
                    focus: visible

                    Keys.onPressed:  {
                        if ((event.key === Qt.Key_M)
                                && (event.modifiers & Qt.ShiftModifier)
                                && (event.modifiers & Qt.ControlModifier)
                                ) {
                            d._maintenance = false;
                            d.ignoreMaintenance = true;
                        }
                    }

                    Rectangle {
                        color: "#000000"
                        opacity: 0.35
                        anchors.fill: parent
                    }

                    Elements.ProgressBar {
                        width: parent.width
                        running: currentItem
                                    ? (currentItem.status === "Downloading" && !currentItem.allreadyDownloaded)
                                    : false

                    }

                    Elements.ButtonBig {
                        id: singleBigButton

                        visible: !!currentItem && !d._maintenance && (root.currentItem.gameId != 760)

                        anchors { right: parent.right; rightMargin: 30; verticalCenter: parent.verticalCenter }

                        buttonText: qsTr("BUTTON_PLAY_DEFAULT_STATE")
                        buttonPauseText: qsTr("BUTTON_PLAY_ON_PAUSE_STATE")
                        buttonDownloadText: qsTr("BUTTON_PLAY_DOWNLOADING_NOW_STATE")
                        buttonErrorText: qsTr("BUTTON_PLAY_ERROR_STATE")
                        buttonDownloadedText: qsTr("BUTTON_PLAY_DOWNLOADED_AND_READY_STATE")

                        isMouseAreaAccepted: qGNA_main.isPageControlAccepted

                        startDownloading: currentItem ? currentItem.status === "Downloading" : false
                        isError: currentItem ? currentItem.status === "Error" : false
                        isPause: currentItem ? currentItem.status === "Paused" : false
                        allreadyDownloaded: currentItem ? currentItem.allreadyDownloaded : false

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

                    Text {
                        id: serviceStatusText

                        visible: !d._maintenance
                        text: currentItem ? currentItem.statusText : ""

                        anchors { left: parent.left; leftMargin: 31; verticalCenter: parent.verticalCenter }
                        font { family: "Segoe UI Light"; pixelSize: 24; weight: Font.Light }
                        color: "#FFFFFF"
                        smooth: true
                    }

                    Elements.ImageButton {
                        id: downloadIcon

                        function update() {
                            opacity = currentItem
                                    ? GamesSwitchHelper.gamesDownloadData.hasOwnProperty(currentItem.serviceId)
                                    : false;
                        }

                        opacity: 1
                        width: 10
                        height: 10
                        source: installPath + 'images/downloadInfo.png'
                        anchors { left: parent.left; bottom: parent.bottom; leftMargin: 17; bottomMargin: 4 }
                        onClicked: {
                            processWidget.visible = true;
                            enabled = false;

                            if (root.currentItem) {
                                GoogleAnalytics.trackEvent('/game/' + root.currentItem.gaName,
                                                           'Game ' + root.currentItem.gaName,
                                                           'Open torrent stat', 'Small info button');
                            }
                        }

                        Behavior on opacity {
                            PropertyAnimation { duration: 200 }
                        }
                    }

                    Timer {
                        id: downloadIconEnable

                        interval: 10
                        onTriggered: downloadIcon.enabled = true
                    }

                    Blocks.ProgressWidget {
                        id: processWidget

                        anchors { left: parent.left; bottom: parent.bottom; leftMargin: 8; bottomMargin: 20 }
                        visible: false
                        onVisibleChanged: {
                            if (!visible) {
                                downloadIconEnable.start();
                            }
                        }

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

                        Component.onCompleted: MouseClick.register(processWidget, function() {
                            processWidget.visible = false;
                        });
                    }

                }

                GameSwitch.Maintenance {
                    visible: d._maintenance
                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                    currentItem: root.currentItem
                    onLaunchGame: {
                        var item = Core.serviceItemByServiceId(serviceId);
                        mainWindow.downloadButtonStart(serviceId);
                        gamesButtonClicked(item)
                        GoogleAnalytics.trackEvent('/game/' + item.gaName,
                                                   'Game ' + item.gaName, 'Play', 'Maintenance');
                    }
                }
            }
        }
    }
}
