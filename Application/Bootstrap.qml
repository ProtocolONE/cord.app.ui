/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Authorization 1.0

Item {
    id: root

    anchors.fill: parent

    Component.onCompleted: init()

    function init() {
        var mainWindowInstance = App.mainWindowInstance();

        Host.hwidChanged.connect(function(result) {
            var mid = Marketing.mid();
            console.log('Authorization use mid `' + mid + '`');
            Authorization.setup({ mid: mid, hwid: encodeURIComponent(result)});
            App.authAccepted = true;
        })

        Host.hwid(true);

        Styles.init();
        Moment.moment.lang(App.language());

        initGoogleAnalytics();
        initEmojiOne();
        initRestApi('https://gnapi.com:8443/restapi');

        // INFO Debug Auth for stage
        //initRestApi('http://api.sabirov.dev');
        //Authorization._gnLoginUrl = 'http://gnlogin.sabirov.dev';

        initAdditionalLayers();

        if (mainWindowInstance) {
            mainWindowInstance.leftMousePress.connect(function(x,y) {
                SignalBus.leftMousePress(root, x, y);
            });

            mainWindowInstance.leftMouseRelease.connect(function(x,y) {
                SignalBus.leftMouseRelease(root, x, y);
            });

            mainWindowInstance.selectService.connect(function(serviceId) {
                if (!App.serviceExists(serviceId)) {
                    SignalBus.navigate('allgame', '')
                    return;
                }

                SignalBus.selectService(serviceId);
            });

            mainWindowInstance.needPakkanenVerification.connect(function() {
                SignalBus.needPakkanenVerification();
            });

            mainWindowInstance.restartUIRequest.connect(root.restartRequest);
            mainWindowInstance.shutdownUIRequest.connect(function() {
                var anyGameRunning = App.currentRunningMainService() ||
                                        App.currentRunningSecondService() ||
                                        App.isAnyServiceLocked();

                if (!anyGameRunning) {
                   SignalBus.beforeCloseUI();
                   mainWindowInstance.shutdownUISlot();
                   return;
                }

                MessageBox.show(qsTr("CLOSE_APP_CAPTION"),
                    qsTr("CLOSE_APP_TEXT"),
                    MessageBox.button.ok | MessageBox.button.cancel,
                    function(result) {
                        if (result == MessageBox.button.ok) {
                            SignalBus.beforeCloseUI();
                            mainWindowInstance.shutdownUISlot();
                        }
                    });
            });
        }
    }

    function initGoogleAnalytics() {
        var cid = AppSettings.value('GoogleAnalytics', 'cid'),
            desktop = Desktop.screenWidth + 'x' + Desktop.screenHeight,
            viewport = Desktop.availableWidth + 'x' + Desktop.availableHeight,
            version = App.fileVersion();

        if (!cid) {
            cid = Uuid.create().substr(1, 36); //INFO Удаляем скобки из строки уида
            AppSettings.setValue('GoogleAnalytics', 'cid', cid);
        }

        console.log("\nAnalytics starting up\n");
        console.log('GameNet Application version: ' + version);
        console.log('CID', cid);
        console.log('Desktop', desktop);

        Ga.setTrackingId('UA-19398372-80');
        Ga.setClientId(cid);
        Ga.setUserAgent('Mozilla/5.0 ' + GoogleAnalyticsHelper.systemVersion());

        Ga.setApplicationName('GameNet');
        Ga.setApplicationVersion(version);
        Ga.setApplicationId('vabanaul.gamenet');
        Ga.setApplicationInstallerId('vabanaul.gamenet');

        Ga.setUserLanguage(GoogleAnalyticsHelper.systemLanguage());
        Ga.setScreenResolution(desktop);
        Ga.setViewportSize(viewport);
        Ga.setOs(GoogleAnalyticsHelper.systemVersion());
        Ga.setSampling(0.2);

        var mid = Marketing.mid();
        if (mid) {
            Ga.setMid(mid);
        }

        Ga.startSession();
    }

    function initEmojiOne() {
        if (App.isQmlViewer()) {
            EmojiOne.ns.imagePathPNG = (installPath + 'Develop/Assets/Smiles/')// Debug for QmlViewer
        } else {
            EmojiOne.ns.imagePathPNG = 'qrc:///Develop/Assets/Smiles/';
        }

        EmojiOne.ns.ascii = true;
        EmojiOne.ns.unicodeAlt = false;
        EmojiOne.ns.cacheBustParam = "";
        EmojiOne.ns.addedImageProps = '"width"= "20" height"="20"'
    }

    function initAdditionalLayers() {
        ContextMenu.init(contextMenuLayer);
        Popup.init(popupLayer);
        MessageBox.init(messageLayer);
        Tooltip.init(tooltipLayer);
    }

    function initRestApi(defaultApiUrl) {
        var url = AppSettings.value('qGNA/restApi', 'url', defaultApiUrl);

        console.log('RestApi use', url);
        RestApi.Core.setup({
                               lang: 'ru',
                               url: url,
                               genericErrorCallback: function(code, message) {
                                   if (code == RestApi.Error.AUTHORIZATION_FAILED
                                       || code == RestApi.Error.ACCOUNT_NOT_EXISTS
                                       || code == RestApi.Error.AUTHORIZATION_LIMIT_EXCEED
                                       || code == RestApi.Error.UNKNOWN_ACCOUNT_STATUS) {
                                       console.log('RestApi generic error', code, message);

                                       if (User.isAuthorized()) {
                                           SignalBus.logoutRequest();
                                       }
                                   }

                               }
                           });
    }

    function resetCredential() {
        CredentialStorage.reset();
    }

    function setAuthInfo(userId, appKey, cookie) {
        AppSettings.setValue("qml/auth/", "authDone", 1);
        App.authSuccessSlot(userId, appKey, cookie);
        User.setCredential(userId, appKey, cookie);
    }

    function requestServices() {
        retryTimer.count += 1;

        RestApi.Service.getUi(function(result) {
            App.fillGamesModel(result);
            SignalBus.servicesLoaded();
            SignalBus.setGlobalState("Authorization");
        }, function(result) {
            console.log('get services error', result);
            retryTimer.start();
        });
    }

    function restartRequest() {
        var mainWindowInstance = App.mainWindowInstance();
        if (!mainWindowInstance) {
            return;
        }

        if (!App.isWindowVisible()) {
            SignalBus.beforeCloseUI();
            mainWindowInstance.restartUISlot(true);
            return;
        }

        MessageBox.show(qsTr("INFO_CAPTION"),
                        qsTr("UPDATE_FOUND_MESSAGE"),
                        MessageBox.button.ok,
                        function(result) {
                            SignalBus.beforeCloseUI();
                            mainWindowInstance.restartUISlot(false);
                        });
    }

    Timer {
        id: retryTimer

        property int count: 0

        function getInterval() {
          var timeout = [5, 10, 15, 20, 60];
          var index = (retryTimer.count >= timeout.length) ? (timeout.length - 1) : retryTimer.count;
          return timeout[index] * 1000;
        }

        interval: getInterval()
        onTriggered: root.requestServices();
    }

    Item {
        id: contextMenuLayer

        anchors.fill: parent
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }

    Item {
        id: messageLayer

        anchors.fill: parent
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
    }

    GlobalProgress {
        id: globalProgressLock

        showWaitImage: false
        maxOpacity: 0.25
        anchors.fill: parent
    }

    ApplicationFocus {
        anchors.fill: parent
    }

    Connections {
        target: SignalBus

        ignoreUnknownSignals: true

        onLogoutRequest: {
            App.logout();
            root.resetCredential();
            App.resetGame();
            SignalBus.logoutDone();
        }

        onLogoutDone: {
            SignalBus.setGlobalState('Authorization');
            TrayPopup.closeAll();
        }

        onAuthDone: {
            root.setAuthInfo(userId, appKey, cookie);
            SignalBus.setGlobalState('Application');
        }

        onSetGlobalProgressVisible: {
            globalProgressLock.interval = (timeout && value) ? timeout : 500;
            globalProgressLock.visible = value;
        }

        onUpdateFinished: {
            root.requestServices();
        }

        onLeftMousePress: ContextMenu.clicked(rootItem, x, y);
        onNavigate: ContextMenu.hide();
        onApplicationActivated: App.updateKeyboardLayout(); // INFO сигнал перенесли из приложения в qml

        onRequestUpdateService: updateService.updateRequired();
    }

    Item {
        id: updateService

        property bool needRestart: false

        function isAnyGamePreventShowMe() {
            return null !== App.findServiceByStatus(['Started', 'Starting', 'Downloading']);
        }

        function updateRequired() {
            if (!updateService.isAnyGamePreventShowMe()) {
                root.restartRequest();
                return;
            }

            updateService.needRestart = true;
        }

        function recheckUpdateRequired() {
            if (!updateService.needRestart) {
                return;
            }

            updateService.updateRequired();
        }

        Connections {
            target: App.mainWindowInstance()

            onServiceFinished: updateService.recheckUpdateRequired();
            onSecondServiceFinished: updateService.recheckUpdateRequired();
            onDownloaderStopped: updateService.recheckUpdateRequired();
            onDownloaderFailed: updateService.recheckUpdateRequired();
            onDownloaderFinished: updateService.recheckUpdateRequired();
        }
    }

    Connections {
        target: App.mainWindowInstance()
        onNavigate: SignalBus.navigate(page, '');
        onWrongCredential: {
            if (userId === User.userId()) {
                SignalBus.logoutRequest()
            }
        }
    }

    FontLoader {
        name: "Open Sans Light";
        source: installPath + "Assets/Fonts/OpenSansLight.ttf"
    }

    FontLoader {
        name: "Open Sans Regular";
        source: installPath + "Assets/Fonts/OpenSansRegular.ttf"
    }

    QtObject {
        id: numConnectionFix

        Component.onCompleted: {
            var settings = App.settingsViewModelInstance();
            if (!settings) {
                return;
            }

            if (AppSettings.value("numConnectionFix", "done", 0) == 1) {
                return;
            }

            AppSettings.setValue("numConnectionFix", "done", 1);
            settings.numConnections = 200;
        }
    }
}
