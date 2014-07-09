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
import "Elements" as Elements
import "Blocks" as Blocks
import "Models" as Models
import "Pages" as Pages
import "Proxy" as Proxy
import "Features/Guide" as Guide
import "Features/Ping" as Ping
import "Features/PublicTest" as PublicTest
import "Features/SilentMode" as SilentMode

import "Blocks/Features/Announcements" as Announcements
import "Features/Maintenance" as Maintenance
import "js/restapi.js" as RestApi
import "js/UserInfo.js" as UserInfo
import "js/Core.js" as Core
import "js/GoogleAnalytics.js" as GoogleAnalytics
import "js/Message.js" as AlertMessage
import "Application/Core/Modules/Host.js" as App
import "Blocks/SecondWindowGame" as SecondWindowGame
import "Features/Games/CombatArmsShop" as CombatArmsShop
import "Features/Premium" as Premium

Item {
    id: mainWindowRectanglw

    width: Core.clientWidth + 8
    height: Core.clientHeight + 8
    clip: true

    signal onWindowPressed(int x, int y);
    signal onWindowReleased(int x, int y);
    signal onWindowClose();
    signal onWindowOpen();
    signal onWindowPositionChanged(int x, int y);
    signal onWindowMinimize();

    signal windowDestroy();

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
            onCompleted: {
                windowDestroy();
                onWindowClose();
            }
            NumberAnimation { target: mainWindowRectanglw; property: "opacity"; from: 1; to: 0;  duration: 250 }
        }

        ParallelAnimation {
            id: hideAnimation;

            running: false;
            onCompleted: {
                App.hide();
                mainWindowRectanglw.opacity = 1;
            }
            NumberAnimation { target: mainWindowRectanglw; property: "opacity"; from: 1; to: 0;  duration: 250 }
        }

        ParallelAnimation {
            id: openAnimation

            running: true;
            onCompleted: onWindowOpen()

            NumberAnimation { target: mainWindowRectanglw; property: "opacity"; from: 0; to: 1;  duration: 750 }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: onWindowPressed(mouseX,mouseY);
            onReleased: onWindowReleased(mouseX,mouseY);
            onPositionChanged: onWindowPositionChanged(mouseX,mouseY);
        }

        Image {
            source: installPath + "Assets/Images/backImage.png"
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

        Connections {
            target: Core.signalBus()

            onNeedAuth: {
                mainAuthModule.logout();
                mainAuthModule.openMoveUpPage()
            }

            onOpenPurchaseOptions: {
                combatArmsPurchaseDetails.setPurchaseOptions(purchaseOptions);
                combatArmsPurchaseDetails.openMoveUpPage();
            }

            onHideMainWindow: hideAnimation.start();
        }

        Connections {
            target: mainWindow

            onNavigate: {
                if (page === 'SettingsPage') {
                    GoogleAnalytics.trackEvent('/TaskList', 'Navigation', 'Switch To Settings');
                    App.activateWindow();
                    qGNA_main.openSettings();
                }

                if (page == 'gogamenetmoney') {
                    RestApi.Billing.isInGameRefillAvailable(function(response) {
                        if (!Money.isOverlayEnable ||
                            !response.enabled) {
                            mainAuthModule.openWebPage("http://www.gamenet.ru/money");
                        }
                    });
                }
            }

            onSelectService: qGNA_main.selectService(serviceId);

            onCloseMainWindow: {
                closeAnimation.start();
            }

            onNeedAuth: {
                Core.needAuth();
            }

            onNeedPakkanenVerification: {
                accountActivation.serviceId = serviceId;
                accountActivation.switchAnimation();
            }

            onServiceFinished: {
                if (serviceState !== RestApi.Error.SERVICE_AUTHORIZATION_IMPOSSIBLE) {
                    return;
                }

                promoKey.serviceId = service;
                promoKey.switchAnimation();
            }

            onAuthBeforeStartGameRequest: {
                mainAuthModule.startAfterAuthGame = serviceId;
                mainAuthModule.openAuthWithGuestTimer();
            }

            onAuthGuestConfirmRequest: {
                mainAuthModule.startAfterLinkServiceId = serviceId;
                mainAuthModule.openLinkGuestOnStartGame();
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
                    App.openExternalUrlWithAuth(url);
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

                UserInfo.refreshPremium();
            }

            selectedGame: Core.currentGame()
            Component.onCompleted: mainAuthModule.startAutoLogin();

            onAuthDone: {
                GoogleAnalytics.userId = userId;
                RestApi.Core.setUserId(userId);
                RestApi.Core.setAppKey(appKey);
                App.authSuccessSlot(userId, appKey, cookie);
                UserInfo.setCredential(userId, appKey, cookie);
                refreshUserInfo();
                userInfoBlock.switchToUserInfo();

                jabber.auth();

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
                UserInfo.logoutDone();
                userInfoBlock.switchToLoginButton();
                userInfoBlock.resetUserInfo();

                jabber.logout();

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

        SecondWindowGame.BuyPage {
            id: buyPage

            Connections {
                target: Core.signalBus()
                onOpenBuyGamenetPremiumPage: {
                    mainWindow.activateWindow();
                    buyPage.openMoveUpPage();
                }

            }
        }

        Premium.PremiumNotifier {
            id: premiumNotifier

            Connections {
                target: Core.signalBus()
                onPremiumExpired: {
                    premiumNotifier.showPremiumExpiredPopup();
                    mainWindow.terminateSecondService();
                }
            }
        }

        Blocks.AccountActivation {
            id: accountActivation

            property string serviceId;

            visible: false
            onPhoneLinked: App.downloadButtonStart(accountActivation.serviceId);
        }

        Blocks.PromoKey {
            id: promoKey

            property string serviceId;

            visible: false
            onKeyActivated: App.downloadButtonStart(promoKey.serviceId);
            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX,mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX,mouseY);
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

        Blocks.FirstLicense {
            id: firstLicense

            anchors.fill: parent
            onAccept: {
                if (firstLicense.serviceId && firstLicense.serviceId != "0" && firstLicense.serviceId != "300007010000000000") {
                    App.setServiceInstallPath(firstLicense.serviceId, firstLicense.pathInput, firstLicense.createShortcut);
                }

                App.acceptFirstLicense(firstLicense.serviceId);
                firstLicense.closeMoveUpPage();
                guide.start();
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

        PublicTest.PublicTestWarning {
            onBackgroundMousePositionChanged: onWindowPositionChanged(mouseX,mouseY);
            onBackgroundMousePressed: onWindowPressed(mouseX,mouseY);
        }

        Image {
            id: closeButtonImage

            z: 10000
            anchors { top: parent.top; right: parent.right; rightMargin: 9; topMargin: 12 }
            source: installPath + "Assets/Images/closeButton.png"
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
                if (!gameExecuteTime.startTime || !item || item.gameType == "browser") {
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
}
