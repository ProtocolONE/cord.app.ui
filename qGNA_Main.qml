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
import qGNA.Library 1.0
import Tulip 1.0
import "." as Current
import "Elements" as Elements
import "Blocks" as Blocks
import "Models" as Models
import "Pages" as Pages
import "Proxy" as Proxy
import "Features/Guide" as Guide
import "Features/Ping" as Ping

import "Blocks/Features/Announcements" as Announcements
import "Features/Maintenance" as Maintenance
import "Elements/Tooltip" as Tooltip
import "js/restapi.js" as RestApi
import "js/UserInfo.js" as UserInfo
import "js/Core.js" as Core
import "js/GoogleAnalytics.js" as GoogleAnalytics
import "js/Message.js" as AlertMessage

import "Proxy/App.js" as App


Item {
    id: mainWindowRectanglw

    clip: true
    width: Core.clientWidth + 8
    height: Core.clientHeight + 8
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

        console.log('Version ', App.fileVersion());
        console.log('Desktop ', desktop);
        console.log('RestApi ', url);

        GoogleAnalytics.init({
                                 saveSettings: Settings.setValue,
                                 loadSettings: Settings.value,
                                 desktop: desktop,
                                 systemVersion: GoogleAnalyticsHelper.systemVersion(),
                                 globalLocale: GoogleAnalyticsHelper.systemLanguage(),
                                 applicationVersion: App.fileVersion()
                             });

        setMidToGoogleAnalytics();
        AlertMessage.setAdapter(alertAdapter);
    }

    Maintenance.Maintenance {}

    BorderImage {
        id: imageBorder

        source: installPath + "images/mainBorder.png"
        width: Core.clientWidth + 8
        height: Core.clientHeight + 8
        smooth: true
        visible: false
    }

    Item {
        id: qGNA_main

        x: 4
        width: Core.clientWidth
        height: Core.clientHeight
        state: "LoadingPage"
        clip: true

        property string lastState
        property bool isPageControlAccepted: !mainAuthModule.isAuthMenuOpen

        function activateNews(force) {
            gamePage.activateNews(force);
        }

        function openSettings(game) {
            if (qGNA_main.state != "SettingsPage") {
                qGNA_main.lastState = qGNA_main.state;
                qGNA_main.state = "SettingsPage";
                settingsPage.selectGame(game);
            }
        }

        function selectService(serviceId) {
            if (serviceId == "0") {
                return;
            }

            Core.activateGameByServiceId(serviceId);

            if (qGNA_main.state != "GamesSwitchPage")
                qGNA_main.state = "GamesSwitchPage"
        }

        ParallelAnimation {
            id: closeAnimation;

            running: false;
            onStarted: imageBorder.visible = false;
            onCompleted: onWindowClose()
            NumberAnimation { target: mainWindowRectanglw; property: "opacity"; from: 1; to: 0;  duration: 250 }
        }

        ParallelAnimation {
            id: hideAnimation;

            running: false;
            onStarted: imageBorder.visible = false;
            onCompleted: {
                App.hide();
                mainWindowRectanglw.opacity = 1;
            }
            NumberAnimation { target: mainWindowRectanglw; property: "opacity"; from: 1; to: 0;  duration: 250 }
        }

        ParallelAnimation {
            id: openAnimation;

            running: true;
            onCompleted: {
                imageBorder.visible = true;
                onWindowOpen()
            }
            NumberAnimation { target: mainWindowRectanglw; property: "opacity"; from: 0; to: 1;  duration: 750 }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: onWindowPressed(mouseX,mouseY);
            onReleased: onWindowReleased(mouseX,mouseY);
            onPositionChanged: onWindowPositionChanged(mouseX,mouseY);
        }

        Image {
            source: installPath + (qGNA_main.state == "HomePage" || qGNA_main.state == "LoadingPage"
                                   ? "images/abstraction.png"
                                   : "images/backImage.png")
            anchors.top: parent.top
        }

        Pages.Game {
            id: gamePage

            visible: qGNA_main.state === "GamesSwitchPage"
            onGameSelection: GoogleAnalytics.trackPageView('/game/' + item.gaName);
        }

        Pages.Home {
            id: homePage

            anchors.fill: parent
            focus: true
            visible: qGNA_main.state === "HomePage"

            onMouseItemClicked: {
                homePage.closeAnimationStart();
                qGNA_main.activateNews(force);
                Core.activateGame(item);
                qGNA_main.state = "GamesSwitchPage";
                GoogleAnalytics.trackPageView('/game/' + item.gaName);
            }
        }

        Pages.SettingsPage {
            id: settingsPage

            anchors.fill: parent
            focus: true
            visible: qGNA_main.state === "SettingsPage"
            width: Core.clientWidth
            height: Core.clientHeight
        }

        Pages.LoadScreen {
            z: 2
            anchors.fill: parent
            focus: true

            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX, mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX, mouseY);
            onUpdateFinished: {
                var serviceId, item;

                imageBorder.visible = true;
                //ping.start();

                qGNA_main.lastState = "HomePage";

                serviceId = App.startingService() || "0";
                qGNA_main.selectService(serviceId);


                if (!App.isAnyLicenseAccepted()) {
                    var item = Core.serviceItemByServiceId(serviceId);

                    firstLicense.withPath = (serviceId != "0" && serviceId != "300007010000000000" && !!item)
                    firstLicense.serviceId = serviceId;

                    if (serviceId != "0" && item) {
                        firstLicense.pathInput = App.getExpectedInstallPath(serviceId);
                    } else {
                        qGNA_main.state = "HomePage";
                    }

                    firstLicense.openMoveUpPage();
                    return;
                }

                qGNA_main.state = "HomePage";

                //INFO App.initFinished also called from c++ slot MainWindow::acceptFirstLicense()
                App.initFinished();
            }
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
                if (!App.isWindowVisible()) {
                    announcementsFeature.showGameInstalledAnnounce(serviceId);
                }
            }
        }

        Blocks.UserInfo {
            id: userInfoBlock

            visible: qGNA_main.state != "LoadingPage"
            anchors { top: parent.top; right: parent.right; topMargin: 43; rightMargin: 30 }
            onLoginRequest: mainAuthModule.switchAnimation();
            onLogoutRequest: mainAuthModule.logout();
            onOpenMoneyRequest: mainAuthModule.openWebPage("http://www.gamenet.ru/money")
            onConfirmGuest: mainAuthModule.openLinkGuest();
            onRequestNickname: enterNickName.openFromMenu();
            onOpenProfileRequest: {
                var url = "http://www.gamenet.ru/users/" + (userInfoBlock.nametech == undefined ? mainAuthModule.userId : userInfoBlock.nametech);
                mainAuthModule.openWebPage(url);
            }
        }

        Blocks.Auth {
            id: mainAuthModule

            property string startAfterLinkServiceId
            property string startAfterAuthGame

            function openWebPage(url) {
                if (!mainAuthModule.isAuthed || !mainAuthModule.authedAsGuest) {
                    App.openExternalBrowser(url);
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
                                            var level = response.userInfo[0].experience.level;
                                            userInfoBlock.setUserInfo(info);
                                            userInfoBlock.setLevel(level);
                                            mainAuthModule.updateGuestStatus(info.guest || "0");
                                        }, function() {});
            }

            function isGuestAuthEnabled() {
                // TODO: так как информация стала полезна 2м фичам, мигрировать на общую.
                return Settings.value("qml/Announcements/", "AnyGameStarted", -1) != 1;
            }

            selectedGame: Core.currentGame()
            guestAuthEnabled: isGuestAuthEnabled()
            Component.onCompleted: mainAuthModule.startAutoLogin();

            onAuthDone: {
                GoogleAnalytics.userId = userId;
                RestApi.Core.setUserId(userId);
                RestApi.Core.setAppKey(appKey);
                guestAuthEnabled = false;
                App.authSuccessSlot(userId, appKey, cookie);
                UserInfo.setCredential(userId, appKey, cookie);
                refreshUserInfo();
                userInfoBlock.switchToUserInfo();

                if (startAfterAuthGame) {
                    App.downloadButtonStart(mainAuthModule.startAfterAuthGame);
                    mainAuthModule.startAfterAuthGame = "";
                }

                GoogleAnalytics.activate();
            }

            onLogoutDone: {
                GoogleAnalytics.userId = null;
                App.logout();
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
                    App.downloadButtonStart(mainAuthModule.startAfterLinkServiceId);
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
                if (!Core.currentGame()) {
                    return;
                }

                Core.currentGame().status = "Normal";
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
            onPhoneLinked: App.downloadButtonStart(accountActivation.serviceId);
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
            id: alertAdapter

            onAlertShown: App.activateWindow();
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

        Blocks.FirstLicense {
            id: firstLicense

            anchors.fill: parent
            onAccept: {
                if (firstLicense.serviceId && firstLicense.serviceId != "0" && firstLicense.serviceId != "300007010000000000") {
                    mainWindow.setServiceInstallPath(firstLicense.serviceId, firstLicense.pathInput, firstLicense.createShortcut);
                }

                mainWindow.acceptFirstLicense(firstLicense.serviceId);
                firstLicense.closeMoveUpPage();
                guide.start();
            }
        }

        Blocks.GameFailed {
            id: gameFailedPage

            onOpenUrl: mainAuthModule.openWebPage(url);
            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX,mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX,mouseY);
        }

        Blocks.GameIsBoring {
            id: gameBoringPage

            onLaunchGame: mainWindow.downloadButtonStart(serviceId);
            onStartClosing: qGNA_main.state = "HomePage";
            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX,mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX,mouseY);
        }

        Guide.WellcomeGuide {
            id: guide
        }

/*
        Ping.Ping {
            id: ping

            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX,mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX,mouseY);
        }
*/
        Proxy.MouseClick {
        }

        Blocks.Tray {
            isFullMenu: mainAuthModule.isAuthed// && !ping.mustBeShown

            function quitTrigger() {
                GoogleAnalytics.trackEvent('/Tray', 'Application', 'Quit');
                closeAnimation.start();
            }

            onMenuClick: {
                switch(name) {
                case 'Profile': {
                    GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'User Profile');
                    mainAuthModule.openWebPage("http://www.gamenet.ru/users/" +
                                               userInfoBlock.nametech == undefined ?  mainAuthModule.userId
                                                                                   : userInfoBlock.nametech)
                    break;
                }
                case 'Balance': {
                    GoogleAnalytics.trackEvent('/Tray', 'Open External Link', 'Money');
                    mainAuthModule.openWebPage("http://www.gamenet.ru/money")
                    break;
                }
                case 'Settings': {
                    GoogleAnalytics.trackEvent('/Tray', 'Navigation', 'Switch To Settings');
                    App.activateWindow();
                    qGNA_main.openSettings()
                }
                break;
                case 'Quit': {
                    var services = Object.keys(Core.runningService).filter(function(e) {
                        var obj = Core.serviceItemByServiceId(e);
                        return obj.gameType != 'browser';
                    }), firstGame;

                    if (!services || services.length === 0) {
                        quitTrigger();
                        break;
                    }

                    firstGame = Core.serviceItemByServiceId(services[0]);

                    AlertMessage.addAlertMessage(qsTr("CLOSE_APP_TOOLTIP_MESSAGE_DESC").arg(firstGame.name),
                                                 qsTr("CLOSE_APP_TOOLTIP_MESSAGE"),
                                                 AlertMessage.button.Ok | AlertMessage.button.Cancel,
                                                 function(button) {
                                                     if (button != AlertMessage.button.Ok) {
                                                         return;
                                                     }

                                                    quitTrigger();
                                                 });

                    break;
                }
                }
            }
        }

        Image {
            id: closeButtonImage

            z: 10000
            anchors { top: parent.top; right: parent.right; rightMargin: 9; topMargin: 12 }
            source: installPath + "images/closeButton.png"
            opacity: closeButtomMouse.containsMouse ? 0.9 : 0.5

            Behavior on opacity {
                NumberAnimation { duration: 225 }
            }

            Elements.CursorMouseArea {
                id: closeButtomMouse

                anchors.fill: parent
                hoverEnabled: true
                onClicked: hideAnimation.start();
            }
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
                var item = Core.serviceItemByServiceId(service);
                if (!item || item.serviceId == "300007010000000000") {
                    return;
                }

                gameExecuteTime.startTime = +(new Date()) / 1000;
            }

            onServiceFinished: {
                if (gameExecuteTime.isAlreadyHandledErrorState(serviceState)) {
                    return;
                }

                var item = Core.serviceItemByServiceId(service);
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

                    Core.activateGame(item);
                    gameBoringPage.openMoveUpPage();
                }
            }
        }

        states: [
            State {
                name: "LoadingPage"
                PropertyChanges { target: mainAuthModule; visible: false }
            },

            State {
                name: "HomePage"
                PropertyChanges { target: mainAuthModule; visible: true }
                StateChangeScript {
                    script:  {
                        GoogleAnalytics.trackPageView('/home');
                    }
                }
            },

            State {
                name: "GamesSwitchPage"
                PropertyChanges { target: mainAuthModule; visible: true }
            },

            State {
                name: "SettingsPage"
                PropertyChanges { target: mainAuthModule; visible: true }
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
            onDoubleClicked: {
                GoogleAnalytics.trackEvent('/Tray', 'Application', 'Quit', 'TopLeft');
                closeAnimation.start();
            }
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

            var item = Core.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('bad service id ' + serviceId);
                return;
            }

            gamePage.gamesButtonClicked(item);
            App.activateWindow();
            App.downloadButtonStart(serviceId);
        }

        onMissClicked: {
            qGNA_main.selectService(serviceId);
            mainWindow.activateWindow();
        }

        onOpenUrlRequest: mainAuthModule.openWebPage(url);
    }

    Blocks.TryLoader {
        source: "Features/Overlay/GameOverlay.qml"
        onFailed: console.log('Can not load overlay');
        onSuccessed: console.log('Overlay ready');
    }
}

