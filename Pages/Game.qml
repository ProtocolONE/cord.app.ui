import QtQuick 1.1
import Tulip 1.0

import "../Elements" as Elements
import "../Blocks" as Blocks
import "../Blocks/GameSwitch" as GameSwitch
import "../Blocks/SecondWindowGame" as SecondWindowGame

import "../js/Core.js" as Core
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../js/PopupHelper.js" as PopupHelper
import "../js/GamesSwitchHelper.js" as GamesSwitchHelper
import "../Features/Maintenance/Maintenance.js" as MaintenanceHelper
import "../Features/Facts" as Feature
import "../Proxy/App.js" as App
import "../js/UserInfo.js" as UserInfo
import "../Proxy/MouseClick.js" as MouseClick
import "../js/Message.js" as AlertMessage
import "../Features/PublicTest/index.js" as PublicTest
import "../Features/Games" as ExtraGameFeatures

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


        var front = Core.previousGame() ? installPath + Core.previousGame().imageBack : "";
        var back = currentItem ? installPath + currentItem.imageBack : "";
        if (App.isSilentMode()) {
            if (Core.previousGame() && Core.previousGame().serviceId == "300012010000000000") {
                front = installPath + Core.previousGame().imageBackSilent
            }

            if (currentItem && currentItem.serviceId == "300012010000000000") {
                back = installPath + currentItem.imageBackSilent
            }
        }

        frontImage.source = front;//Core.previousGame() ? installPath + Core.previousGame().imageBack : ""
        backImage.source = back;//currentItem ? installPath + currentItem.imageBack : ""

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
                           (item.status === 'Normal' || item.status === 'DownloadFinished' || item.status === 'Starting') &&
                           (item.allreadyDownloaded || Core.isServiceInstalled(serviceId)))
                        : false
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

            Core.updateProgress(item);
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

            Core.updateProgress(item);
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

            Core.updateProgress(item);
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

            Core.updateProgress(item);
        }

        onDownloaderStopped: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Paused";
            console.log("DOWNLOAD STOPPED");

            Core.updateProgress(item);
        }

        onDownloaderStopping: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.status = "Paused";
            console.log("DOWNLOAD STOPPING");

            Core.updateProgress(item);
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

            Core.updateProgress(item);
        }

        onDownloaderFinished: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.progress = 100;
            item.status = 'DownloadFinished';
            item.allreadyDownloaded = true;

            console.log("DOWNLOAD FINISHED");

            Core.updateProgress(item);

            MaintenanceHelper.updatedService[service] = true;
            d.updateMaintenance();

            if (d._maintenance) {
                MaintenanceHelper.showMaintenanceEnd[service] = 1;
                item.statusText = '';
                item.status = "Normal";
                return;
            }

            var isPopUpCase = (App.isWindowVisible() && Core.currentGame() !== item); //QGNA-378
            if (isPopUpCase) {
                item.status = "Normal";
                item.statusText = qsTr("TEXT_PROGRESSBAR_DOWNLOADED_AND_READY_STATE")
                showPopupGameInstalled(service);
                return;
            }

            item.status = "Starting";
            item.statusText = qsTr("TEXT_PROGRESSBAR_STARTING_STATE")
            if (!App.executeService(service)) {
                item.statusText = '';
                item.status = "Normal";
            }

        }

        onProgressbarChange: { // @DEPRECATED
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            var isInstalled = Core.isServiceInstalled(serviceId);

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
                    payloadUploadRate: payloadUploadRate,
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

            Core.updateProgress(item);
        }

        onDownloadProgressChanged: {
            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId)
                return;
            }

            var isInstalled = Core.isServiceInstalled(serviceId);
            GamesSwitchHelper.gamesDownloadData[serviceId] = {
                totalWantedDone: totalWantedDone,
                totalWanted: totalWanted,
                directTotalDownload: directTotalDownload,
                peerTotalDownload: peerTotalDownload,
                payloadTotalDownload: payloadTotalDownload,
                peerPayloadDownloadRate: peerPayloadDownloadRate,
                payloadDownloadRate: payloadDownloadRate,
                directPayloadDownloadRate: directPayloadDownloadRate,
                payloadUploadRate: payloadUploadRate,
                totalPayloadUpload: totalPayloadUpload
            }

            processWidget.refresh();

            item.progress = progress;
            item.statusText = (isInstalled ? qsTr("TEXT_PROGRESSBAR_UPDATING_NOW_STATE") :
                                             qsTr("TEXT_PROGRESSBAR_DOWNLOADING_NOW_STATE"))
            .arg(Math.round(totalWantedDone / 10000) / 100)
            .arg(Math.round(totalWanted / 10000) / 100);

            Core.updateProgress(item);
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

            Core.updateProgress(item);
        }

        onSecondServiceStarted: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.secondStatus = "Started";
            Core.secondServiceStarted(service);
        }

        onSecondServiceFinished: {
            var item = Core.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            item.secondStatus = "Normal"; //(Может и ошибку надо выставлять в случаи не успех)
            Core.secondServiceFinished(service);
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
                        id: rewardsButton;

                        toolTip: qsTr('REWARDS_TOOLTIP')
                        text: qsTr('REWARDS_BUTTON')
                        source: installPath + "images/menu/Rewards.png"
                        anchors { top: parent.top; right: parent.right }
                        anchors { topMargin: 13; rightMargin: 30 }
                        tooltipGlueCenter: true
                        onClicked: mainAuthModule.openWebPage("http://rewards.gamenet.ru/");
                    }

                    SecondWindowGame.PremiumAccountLabel {
                        id: premiumButton

                        function getText() {
                            if (!UserInfo.isPremium()) {
                                return qsTr("ADVANCED_ACCOUNT_HINT");
                            }

                            var durationInDays = Math.floor(UserInfo.premiumDuration() / 86400);
                            if (durationInDays > 0) {
                                return qsTr("ADVANCED_ACCOUNT_HINT_IN_DAYS").arg(durationInDays);
                            } else {
                                return qsTr("ADVANCED_ACCOUNT_HINT_TODAY");
                            }
                        }

                        function getVisible() {
                            if (!root.currentItem) {
                                return false;
                            }

                            if (!root.currentItem.secondAllowed) {
                                return false;
                            }

                            return UserInfo.isAuthorized() && !UserInfo.isGuest();
                        }

                        visible: premiumButton.getVisible()
                        anchors { right: parent.right; rightMargin: 30 }
                        anchors { top: parent.top; topMargin: 100 }
                        text: premiumButton.getText();
                        onClicked: Core.openBuyGamenetPremiumPage();
                        toolTip: qsTr("BUY_PREMIUM_BUTTON_TOOLTIP")
                    }

                    Blocks.NewsBlock {
                        id: newsBlock

                        anchors { top: parent.top; left: parent.left }
                        anchors { topMargin: 11; leftMargin: 30 }
                        filterGameId: currentItem ? currentItem.gameId : "671"
                    }

                    Blocks.SocialNet {
                        id: socialBlock

                        anchors { bottom: parent.bottom; right: parent.right }
                        anchors { bottomMargin: 20; rightMargin: 30 }
                    }

                    Feature.Facts {
                        id: factsBlock;

                        visible: (!d._maintenance) && (!d._maintenanceEndPause)
                        anchors { bottom: parent.bottom; left: parent.left }
                        anchors { bottomMargin: 20; leftMargin: 30 }
                    }

                    ExtraGameFeatures.GameFeatureContainer {
                        visible: mainAuthModule.isAuthed && !mainAuthModule.authedAsGuest
                        currentGameId: currentItem ? currentItem.gameId : ""
                        width: 150;
                        anchors {
                            top: rewardsButton.bottom;
                            right: parent.right;
                            bottom: socialBlock.top;
                            topMargin: 3;
                            bottomMargin: 13;
                            rightMargin: 30;
                        }
                    }

                    Image {
                        visible: settingsViewModel.isPublicTestVersion

                        source: installPath + "/images/warning.png"
                        anchors { bottom: factsBlock.top; left: factsBlock.left }
                        anchors { bottomMargin: 10; leftMargin: 0 }

                        Elements.CursorMouseArea {
                            id: warningButtonMouser

                            anchors.fill: parent
                            hoverEnabled: true
                            toolTip: qsTr("PUBLIC_TEST_TOOLTIP")
                            onClicked: PublicTest.show();
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

                        visible: !!currentItem && !d._maintenance

                        anchors {
                            right: parent.right
                            rightMargin: 30 + secondAuthButton.buttonWidth + secondAuthButton.spacing
                            verticalCenter: parent.verticalCenter
                        }

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

                        isStarted: currentItem ? currentItem.status === "Started" || currentItem.status === "Starting" : false
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

                        Blocks.SecondAuthButton {
                            id: secondAuthButton

                            function isPremiumAvailable() {
                                if (!root.currentItem) {
                                    return false;
                                }

                                if (!root.currentItem.secondAllowed) {
                                    return false;
                                }

                                return UserInfo.isAuthorized() && UserInfo.isPremium();
                            }

                            function getIsRunning() {
                                if (!root.currentItem) {
                                    return false;
                                }

                                return root.currentItem.secondStatus === "Started"
                            }

                            anchors.fill: parent

                            onAuthClick: secondAuthModule.openMoveUpPage();
                            onLogoutClick: secondAuthModule.logout();
                            onPlayClick: {
                                mainWindow.executeSecondService(currentItem.serviceId,
                                                                secondAuthModule.userId,
                                                                secondAuthModule.appKey);
                            }

                            isAuthed: secondAuthModule.isAuthed
                            nickName: secondAuthModule.nickname

                            playEnabled: singleBigButton.isStarted
                            visible: secondAuthButton.isPremiumAvailable()
                            isRunning: secondAuthButton.getIsRunning()
                            enabled: !Core.isAnySecondServiceRunning()
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
                            payloadUploadRate = progressValue('payloadUploadRate')
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

    Blocks.SecondAuth {
        id: secondAuthModule

        selectedGame: Core.currentGame()
        anchors.fill: parent
        Component.onCompleted: secondAuthModule.startAutoLogin()

        Connections {
            target: UserInfo.instance();
            onIsPremiumChanged: {
                if (!UserInfo.isPremium()) {
                    secondAuthModule.logout();
                }
            }
        }
    }
}
