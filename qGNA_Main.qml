/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import qGNA.Library 1.0
import Tulip 1.0
import Qt 4.7
import "." as Current
import "Elements" as Elements
import "Blocks" as Blocks
import "Models" as Models

import "Blocks/Features/Announcements" as Announcements
import "Blocks/Features/Maintenance" as Maintenance
import "Elements/Tooltip" as Tooltip
import "js/restapi.js" as RestApi
import "js/userInfo.js" as UserInfo
import "js/GameListModelHelper.js" as GameListModelHelper
import "js/GoogleAnalytics.js" as GoogleAnalytics

Rectangle {
    id: mainWindowRectanglw
    clip: true
    width: 808
    height: 408
    color: "#00000000"

    signal onWindowPressed(int x, int y);
    signal onWindowReleased(int x, int y);
    signal onWindowClose();
    signal onWindowOpen();
    signal onWindowPositionChanged(int x, int y);
    signal onWindowMinimize();


    function setMidToGoogleAnalytics() {
        var mid = Marketing.mid();
        if (!mid) {
            return;
        }

        RestApi.Marketing.getMidDetails(mid,
                                        function(response) {
                                            var midDescription = (response.agentId || "") +
                                                '-' + (response.company || "") +
                                                '-' + (response.urlId || "");
                                            GoogleAnalytics.setMidDescription(midDescription);
                                        });
    }

    Component.onCompleted: {
        var desktop = Desktop.screenWidth + 'x' + Desktop.screenHeight
            , url = Settings.value('qGNA/restApi', 'url', 'https://gnapi.com:8443/restapi');

        RestApi.Core.setup({lang: 'ru', url: url});

        console.log('Version ', mainWindow.fileVersion);
        console.log('Desktop ', desktop);
        console.log('RestApi ', url);

        GoogleAnalytics.init({
                                 saveSettings: Settings.setValue,
                                 loadSettings: Settings.value,
                                 desktop: desktop,
                                 systemVersion: GoogleAnalyticsHelper.systemVersion(),
                                 globalLocale: GoogleAnalyticsHelper.systemLanguage(),
                                 applicationVersion: mainWindow.fileVersion
                             });

        setMidToGoogleAnalytics();
    }

    Maintenance.Maintenance {
    }

    Models.GamesListModel {
        id: gamesListModel

        Component.onCompleted: GameListModelHelper.initGameItemList(gamesListModel);
    }

    BorderImage {
        id: imageBorder

        source: installPath + "images/mainBorder.png"
        x:0
        y:0
        width: 808; height: 408
        border.left: 0; border.top: 0
        border.right: 0; border.bottom: 0
        smooth: true
        visible: false
    }

    Rectangle {
        id: qGNA_main

        x: 4; y: 0;
        width: 800
        height: 400
        state: "LoadingPage"
        color: "#00000000"
        clip: true

        property int currentGameIndex: -1
        property variant currentGameItem

        property string lastState
        property bool isPageControlAccepted: !mainAuthModule.isAuthMenuOpen

        FontLoader { id: fontTahoma; source: installPath + "fonts/Tahoma.ttf"}
        FontLoader { id: fontMyriadProLight; source: installPath + "fonts/MyriadProLight.ttf" }

        function activateWindow() {
            qGNA_main.scale = 1;
            qGNA_main.opacity = 1;
        }

        function openSettings() {
            if (qGNA_main.state != "SettingsPage") {
                qGNA_main.lastState = qGNA_main.state;
                qGNA_main.state = "SettingsPage";
            }
        }

        ParallelAnimation {
            id: closeAnimation;

            running: false;
            NumberAnimation { target: qGNA_main; property: "scale"; from: 1; to: 0.05; duration: 150 }
            NumberAnimation { target: qGNA_main; property: "opacity"; from: 1; to: 0;  duration: 150 }
            onStarted: imageBorder.visible = false;
            onCompleted: {
                console.log('qml closeAnimation onWindowClose');
                onWindowClose()
            }
        }

        ParallelAnimation {
            id: hideAnimation;

            running: false;
            NumberAnimation { target: qGNA_main; property: "scale"; from: 1; to: 0.05; duration: 150 }
            NumberAnimation { target: qGNA_main; property: "opacity"; from: 1; to: 0;  duration: 150 }
            onStarted: imageBorder.visible = false;
            onCompleted: {
                mainWindow.hide();
                qGNA_main.activateWindow();
            }
        }

        ParallelAnimation {
            id: openAnimation;

            running: true;
            NumberAnimation { target: qGNA_main; property: "scale"; from: 0.05; to: 1; duration: 250 }
            NumberAnimation { target: qGNA_main; property: "opacity"; from: 0; to: 1;  duration: 250 }
            onCompleted: {
                imageBorder.visible = true;
                onWindowOpen()
            }
        }

        Image {
            source: installPath  + "images/backImage.png"
            anchors.centerIn: parent

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    onWindowPressed(mouseX,mouseY);
                    userInfoBlock.closeMenu();
                }
                onReleased: onWindowReleased(mouseX,mouseY);
                onPositionChanged: onWindowPositionChanged(mouseX,mouseY);
            }

        }

        Blocks.GamesSwitch {
            id: gamesSwitchPageModel

            visible: false
            onHomeButtonClicked: qGNA_main.state = "HomePage";
            onGameSelection: {
                GoogleAnalytics.trackPageView('/game/' + item.gaName);
                userInfoBlock.closeMenu();
            }
        }

        Loader {
            id: pageLoader;

            anchors.fill: parent;
            focus: true;
        }

        function selectService(serviceId) {
            if (serviceId == "0") {
                return;
            }

            var item = GameListModelHelper.serviceItemByServiceId(serviceId);
            if (!item ) {
                return;
            }

            qGNA_main.currentGameItem = item;
            if (qGNA_main.state != "GamesSwitchPage")
                qGNA_main.state = "GamesSwitchPage"
        }

        Connections {
            target: mainWindow
            onSelectService: qGNA_main.selectService(serviceId);

            onCloseMainWindow: {
                closeAnimation.start();
            }

            onNeedAuth: {
                mainAuthModule.logout();
                mainAuthModule.openMoveUpPage()
            }

            onNeedPakkanenVerification: {
                accountActivation.serviceId = serviceId;
                accountActivation.switchAnimation();
            }

            onAuthBeforeStartGameRequest: {
                mainAuthModule.startAfterAuthGame = serviceId;
                mainAuthModule.openAuthWithGuestTimer();
            }

            onAuthGuestConfirmRequest: {
                mainAuthModule.startAfterLinkServiceId = serviceId;
                mainAuthModule.openLinkGuestOnStartGame();
            }

            onServiceInstalled: {
                if (!mainWindow.isWindowVisible()) {
                    announcementsFeature.showGameInstalledAnnounce(serviceId);
                }
            }
        }

        Connections {
            target: pageLoader.item
            onTestAndCloseSignal: userInfoBlock.closeMenu();
            onFinishAnimation: {
                var serviceId, item;
                if (qGNA_main.state === "LoadingPage") {
                    qGNA_main.lastState = "HomePage";

                    mainWindow.updateFinishedSlot();

                    serviceId = mainWindow.startingService() || "0";
                    qGNA_main.selectService(serviceId);

                    if (!mainWindow.anyLicenseAccepted()) {
                        var item = GameListModelHelper.serviceItemByServiceId(serviceId);

                        firstLicense.withPath = (serviceId != "0" && serviceId != "300007010000000000" && !!item)
                        firstLicense.serviceId = serviceId;

                        if (serviceId != "0" && item) {
                            firstLicense.pathInput = mainWindow.getExpectedInstallPath(serviceId);
                        } else {
                            qGNA_main.state = "HomePage";
                        }

                        firstLicense.openMoveUpPage();
                        return;
                    }

                    if (qGNA_main.currentGameIndex < 0) {
                        qGNA_main.state = "HomePage";
                    }

                    mainWindow.initFinished();
                }
            }
        }

        Image {
            id: backTextImage
            x: 37
            y: 33
            smooth: true
            source: installPath + "images/gamenet.png"
        }

        Blocks.UserInfo {
            id: userInfoBlock

            visible: false
            anchors { top: parent.top; right: parent.right; topMargin: 35; rightMargin: 20 }
            onLoginRequest: mainAuthModule.switchAnimation();
            onLogoutRequest: mainAuthModule.logout();
            onOpenMoneyRequest: mainAuthModule.openWebPage("http://www.gamenet.ru/money")
            onOpenSettings: qGNA_main.openSettings()
            onConfirmGuest: mainAuthModule.openLinkGuest();
            onRequestNickname: enterNickName.openFromMenu();
        }

        Blocks.Auth {
            id: mainAuthModule

            property string startAfterLinkServiceId
            property string startAfterAuthGame

            function openWebPage(url) {
                if (!mainAuthModule.isAuthed || !mainAuthModule.authedAsGuest) {
                    mainWindow.openExternalBrowser(url);
                    return;
                }

                mainAuthModule.openLinkGuestOnOpenPage();
            }

            function refreshUserInfo() {
                RestApi.User.getProfile(mainAuthModule.userId, function(response) {
                                            if (!response || !response.userInfo || response.userInfo.length < 1) {
                                                return;
                                            }

                                            var info = response.userInfo[0].shortInfo;
                                            userInfoBlock.setUserInfo(info);
                                            mainAuthModule.updateGuestStatus(info.guest || "0");
                                        }, function() {});
            }

            function isGuestAuthEnabled() {
                // TODO: так как информация стала полезна 2м фичам, мигрировать на общую.
                return Settings.value("qml/Announcements/", "AnyGameStarted", -1) != 1;
            }

            selectedGame: qGNA_main.currentGameItem
            guestAuthEnabled: isGuestAuthEnabled()
            Component.onCompleted: mainAuthModule.startAutoLogin();

            onAuthDone: {
                GoogleAnalytics.userId = userId;
                guestAuthEnabled = false;
                RestApi.Core.setUserId(userId);
                RestApi.Core.setAppKey(appKey);
                mainWindow.authSuccessSlot(userId, appKey, cookie);
                UserInfo.setCredential(userId, appKey, cookie);
                refreshUserInfo();
                userInfoBlock.switchToUserInfo();

                if (startAfterAuthGame) {
                    mainWindow.downloadButtonStart(mainAuthModule.startAfterAuthGame);
                    mainAuthModule.startAfterAuthGame = "";
                }

                GoogleAnalytics.activate();
            }

            onLogoutDone: {
                GoogleAnalytics.userId = null;
                mainWindow.logout();
                UserInfo.reset();
                userInfoBlock.switchToLoginButton();
                userInfoBlock.resetUserInfo();

                if (qGNA_main.state == "SettingsPage") {
                    qGNA_main.lastState = "HomePage"
                    qGNA_main.state = "HomePage"
                }
            }

            onLinkGuestDone: {
                if (mainAuthModule.startAfterLinkServiceId) {
                    mainWindow.downloadButtonStart(mainAuthModule.startAfterLinkServiceId);
                    mainAuthModule.startAfterLinkServiceId = "";
                }
            }

            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX,mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX,mouseY);

            onAutoLoginFailed: {
                GoogleAnalytics.userId = null;
                GoogleAnalytics.activate();
            }
        }

        Blocks.LicenseBlock {
            id: licenseBlock

            visible: false
            anchors.fill: parent
            onCanceled: {
                if (!qGNA_main.currentGameItem) {
                    return;
                }

                qGNA_main.currentGameItem.status = "Normal";
            }
        }

        Blocks.SelectMw2Server {
            visible: false
            anchors.fill: parent
        }

        Blocks.AccountActivation {
            id: accountActivation

            visible: false
            property string serviceId;
            onPhoneLinked: mainWindow.downloadButtonStart(accountActivation.serviceId);
        }

        Connections {
            target: enterNickNameViewModel
            onStartCheck: enterNickName.openFromExecutor();
        }

        Connections {
            target: mainWindow
            onDownloadButtonStartSignal: enterNickName.forceCancel();
        }

        Blocks.EnterNickname {
            id: enterNickName

            property bool _gameExecutorHookStarted: false;

            function openFromExecutor() {
                enterNickName.isCancelEnabled = false;
                _gameExecutorHookStarted = true;
                startCheck();
            }

            function openFromMenu() {
                if (_gameExecutorHookStarted) {
                    return;
                }

                enterNickName.isCancelEnabled = true;
                startCheck();
            }

            function forceCancel() {
                if (_gameExecutorHookStarted) {
                    _gameExecutorHookStarted = false;
                    enterNickNameViewModel.failed();
                }

                enterNickName.closeMoveUpPage();
            }

            visible: false
            anchors.fill: parent
            nickname: userInfoBlock.nickname
            nametech: userInfoBlock.nametech
            isAuthed: mainAuthModule.isAuthed

            onNickNameChanged: userInfoBlock.nickname = nickName;
            onTechNickChanged: userInfoBlock.nametech = techName;

            onSuccess: {
                if (_gameExecutorHookStarted) {
                    _gameExecutorHookStarted = false;
                    enterNickNameViewModel.success();
                }
            }

            onFailed: {
                if (_gameExecutorHookStarted) {
                    _gameExecutorHookStarted = false;
                    enterNickNameViewModel.failed();
                }
            }
        }

        Blocks.AlertAdapter {
            onAlertShown: mainWindow.activateWindow();
        }

        Item {
            id: alertModuleSubstateId

            anchors.fill: parent
            opacity: 0

            MouseArea {
                // Нужен, что-бы перекрыть задние ховеры
                anchors.fill: parent
                hoverEnabled: true
            }

            Elements.CursorMouseArea {
                anchors.fill: parent
                visible: parent.opacity
                onPressed: onWindowPressed(mouseX,mouseY);
                onReleased: onWindowReleased(mouseX,mouseY);
                onPositionChanged: onWindowPositionChanged(mouseX,mouseY);
            }
        }

        Connections {
            target: trayMenu
            onMenuClick: {
                switch(index) {
                case TrayWindow.ProfileMenu: {
                    GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'User Profile');
                    mainAuthModule.openWebPage("http://www.gamenet.ru/users/" +
                                               userInfoBlock.nametech == undefined ?  mainAuthModule.userId
                                                                                   : userInfoBlock.nametech)
                    break;
                }
                case TrayWindow.MoneyMenu: {
                    GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'Money');
                    mainAuthModule.openWebPage("http://www.gamenet.ru/money")
                    break;
                }
                case TrayWindow.SettingsMenu: {
                    GoogleAnalytics.trackEvent('/Tray', 'Navigation', 'Switch To Settings');
                    mainWindow.activateWindow();
                    userInfoBlock.closeMenu();
                    qGNA_main.openSettings()
                }
                break;
                case TrayWindow.QuitMenu: {
                    GoogleAnalytics.trackEvent('/Tray', 'Application', 'Quit');
                    closeAnimation.start();
                    break;
                }
                }
            }

            onActivate: qGNA_main.activateWindow();
        }

        Image {
            id: closeButtonImage

            x: 780
            y: 10
            source: installPath + "images/closeButton.png"
            opacity: 0.5

            NumberAnimation { id: closeButtonDownAnimation; running: false; target: closeButtonImage; property: "opacity"; from: 0.9; to: 0.5; duration: 225 }
            NumberAnimation { id: closeButtonUpAnimation; running: false; target: closeButtonImage; property: "opacity"; from: 0.5; to: 0.9; duration: 225 }
            Elements.CursorMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: hideAnimation.start();
                onEntered: closeButtonUpAnimation.start()
                onExited: closeButtonDownAnimation.start()
            }
        }

        Blocks.FirstLicense {
            id: firstLicense

            anchors.fill: parent
            onAccept: {
                if (firstLicense.serviceId && firstLicense.serviceId != "0" && firstLicense.serviceId != "300007010000000000") {
                    mainWindow.setServiceInstallPath(firstLicense.serviceId, firstLicense.pathInput, firstLicense.createShortcut);
                }

                mainWindow.acceptFirstLicense(firstLicense.serviceId);
                firstLicense.closeMoveUpPage();
            }
        }

        Blocks.GameFailed {
            id: gameFailedPage

            onOpenUrl: mainAuthModule.openWebPage(url);
        }

        Blocks.GameIsBoring {
            id: gameBoringPage

            onLaunchGame: mainWindow.downloadButtonStart(serviceId);
            onStartClosing: qGNA_main.state = "HomePage";
        }

        Connections {
            id: gameExecuteTime

            property variant startTime

            function showCats(serviceId) {
                var succes = parseInt(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "successCount", "0"), 10);
                var fail = parseInt(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "failedCount", "0"), 10);
                return (succes + fail) <= 2;
            }

            function isAlreadyHandledErrorState(serviceState) {
                return [5, 6, 102, 125, 601, 603].indexOf(serviceState) != -1;
            }

            target: mainWindow

            onServiceStarted: {
                var item = GameListModelHelper.serviceItemByServiceId(service);
                if (!item || item.serviceId == "300007010000000000") {
                    return;
                }

                gameExecuteTime.startTime = +(new Date()) / 1000;
            }

            onServiceFinished: {
                if (gameExecuteTime.isAlreadyHandledErrorState(serviceState)) {
                    return;
                }

                var item = GameListModelHelper.serviceItemByServiceId(service);
                if (!gameExecuteTime.startTime || !item || item.serviceId == "300007010000000000") {
                    return;
                }

                var finishTime = +(new Date()) / 1000;
                var time = finishTime - gameExecuteTime.startTime;
                gameExecuteTime.startTime = undefined;

                if (time < 20) {
                    gameFailedPage.currentItem = item;
                    gameFailedPage.openMoveUpPage();
                } else if (time < 300) {
                    if (!gameExecuteTime.showCats(service)) {
                        return;
                    }

                    gameBoringPage.currentItem = item;
                    gameBoringPage.openMoveUpPage()
                }
            }
        }

        states: [
            State {
                name: "LoadingPage"
                PropertyChanges { target: pageLoader; source: "Models/LoadScreenModel.qml" }
                PropertyChanges { target: gamesSwitchPageModel ; visible: false; }
                PropertyChanges { target: mainAuthModule; visible: false }
                PropertyChanges { target: userInfoBlock; visible: false }
                PropertyChanges { target: backTextImage; visible: true }
            },

            State {
                name: "HomePage"
                PropertyChanges { target: pageLoader; source: "Models/HomeModel.qml" }
                PropertyChanges { target: gamesSwitchPageModel ; visible: false; }
                PropertyChanges { target: mainAuthModule; visible: true }
                PropertyChanges { target: userInfoBlock; visible: true }
                PropertyChanges { target: backTextImage; visible: true }
                StateChangeScript {
                    script:  {
                        GoogleAnalytics.trackPageView('/home');
                    }
                }
            },

            State {
                name: "GamesSwitchPage"
                PropertyChanges { target: gamesSwitchPageModel; visible: true; }
                PropertyChanges { target: pageLoader; visible: false; }
                PropertyChanges { target: mainAuthModule; visible: true }
                PropertyChanges { target: userInfoBlock; visible: true }
                PropertyChanges { target: backTextImage; visible: false }
            },

            State {
                name: "SettingsPage"
                PropertyChanges { target: pageLoader; source: "Models/SettingsModel.qml" }
                PropertyChanges { target: gamesSwitchPageModel ; visible: false; }
                PropertyChanges { target: pageLoader; visible: true; }
                PropertyChanges { target: mainAuthModule; visible: true }
                PropertyChanges { target: userInfoBlock; visible: true }
                PropertyChanges { target: backTextImage; visible: false }
                StateChangeScript {
                    script:  {
                        GoogleAnalytics.trackPageView('/settings');
                    }
                }
            }
        ]
    }

    Item {
        anchors { left: parent.left; top: parent.top }
        width: 20
        height: 20

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: closeAnimation.start();
        }
    }

    Elements.PopupWindow {}

    Tooltip.Tooltip {}

    Announcements.Announcements {
        id: announcementsFeature
        isAuthed: mainAuthModule.isAuthed
        onGamePlayClicked: {
            if (!serviceId || serviceId == 0) {
                console.log('bad service id ' + serviceId);
                return;
            }

            var item = GameListModelHelper.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('bad service id ' + serviceId);
                return;
            }

            gamesSwitchPageModel.gamesButtonClicked(item);
            mainWindow.activateWindow();
            mainWindow.downloadButtonStart(serviceId);
        }

        onMissClicked: {
            qGNA_main.selectService(serviceId);
            mainWindow.activateWindow();
        }

        onOpenUrlRequest: mainAuthModule.openWebPage(url);
    }

}

