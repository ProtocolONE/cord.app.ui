import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Authorization 1.0
import Application.Core.Config 1.0
import Application.Core.ServerTime 1.0

import Application.Models 1.0

Item {
    id: root

    anchors.fill: parent

    Component.onCompleted: init()

    function init() {
        var mainWindowInstance = App.mainWindowInstance();

        Host.hwidChanged.connect(function(result) {
            var mid = Marketing.mid();
            console.log('Authorization use mid `' + mid + '`');
            var authConfig = {
                timeout: 15000,
                mid: mid,
                hwid: encodeURIComponent(result),
                authUrl: Config.value('auth\\url', 'http://127.0.0.1'),
                authVersion: Config.value('auth\\version', 'v1'),
                localWebSocketUrl: Config.value('auth\\localWebSocketUrl', 'ws://127.0.0.1'),
                debug: Config.value('auth\\debug', 'false') === 'true'
            };


            if (authConfig.debug) {
                console.log('AuthConfig:' , JSON.stringify(authConfig, null, 2))
            }

            Authorization.setup(authConfig);
            App.authAccepted = true;
        })

        Host.hwid(true);

        Styles.init();
        Moment.moment.lang(App.language());

        //Config.show();

        initGoogleAnalytics();
        initEmojiOne();

        initRestApi();

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
        if (Config.value('googleAnalytic\\enabled', 'false') != "true") {
            return;
        }

        var cid = AppSettings.value('GoogleAnalytics', 'cid'),
            desktop = Desktop.screenWidth + 'x' + Desktop.screenHeight,
            viewport = Desktop.availableWidth + 'x' + Desktop.availableHeight,
            version = App.fileVersion();

        if (!cid) {
            cid = Uuid.create().substr(1, 36); //INFO Удаляем скобки из строки уида
            AppSettings.setValue('GoogleAnalytics', 'cid', cid);
        }

        console.log("\nAnalytics starting up\n");
        console.log('ProtocolOne Application version: ' + version);
        console.log('CID', cid);
        console.log('Desktop', desktop);

        var trackingId = Config.value('googleAnalytic\\trackingId', '');
        if (!trackingId) {
            console.warn("Google analytic tracing id not found. GA disabled.")
            return;
        }

        Ga.setTrackingId(trackingId);
        Ga.setClientId(cid);
        Ga.setUserAgent('Mozilla/5.0 ' + GoogleAnalyticsHelper.systemVersion());

        var appName = Config.value('applicationName', '') || 'ProtocolOne';
        Ga.setApplicationName(appName);
        Ga.setApplicationVersion(version);
        Ga.setApplicationId('publisher.' + appName);
        Ga.setApplicationInstallerId('publisher.' + appName);

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

    function initRestApi() {
        // Deprecated old API:
        var url = Config.api();
        if (!Config.overrideApi()) {
            url = AppSettings.value('qGNA/restApi', 'url', url);
        }

        if (Config.debugApi()) {
            RestApi.http.logRequest = true;
        }

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

//                                       if (User.isAuthorized()) {
//                                           SignalBus.logoutRequest();
//                                       }
                                   }

                               }
                           });

        // ProtocolOne Api:
        if (Config.value('api\\debug', 'false') === 'true') {
            RestApi.http.logRequest = true;
        }

        RestApi.Core.setupEx({
            version: Config.value('api\\version', 'v1'),
            url: Config.value('api\\url', 'http://local-auth.protocol.one:3000'),
            jwtRefreshCallback: function() {
                User.refreshTokens();
            }
        });

        ServerTime.refreshServerTime();
    }

    function requestServices() {
        retryTimer.count += 1;

        RestApi.App.getUi(function(code, result) {
            if (!RestApi.ErrorEx.isSuccess(code)) {
                retryTimer.start();
                return;
            }

            App.fillGamesModel(result);

            App.setSingleGameMode(Games.count == 1)

            SignalBus.servicesLoaded();
            SignalBus.setGlobalState("Authorization");
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
        // ### TODO по хорошему это не должно быть тут

        onAuthTokenChanged: {
            var jwt = User.getAccessToken();
            RestApi.Core.setJwt(jwt.value, jwt.exp);
        }

        onLogoutRequest: {
            RestApi.Core.setJwt();
            App.logout();
            App.resetGame();
            SignalBus.logoutDone();
        }

        onLogoutDone: {
            SignalBus.setGlobalState('Authorization');
            TrayPopup.closeAll();
        }

        onAuthDone: {
            ServerTime.refreshServerTime();
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
            onDownloaderStopped: updateService.recheckUpdateRequired();
            onDownloaderFailed: updateService.recheckUpdateRequired();
            onDownloaderFinished: updateService.recheckUpdateRequired();
        }
    }

    Connections {
        target: App.mainWindowInstance()
        onNavigate: SignalBus.navigate(page, '');
    }

    FontLoader {
        name: "Open Sans Light";
        source: installPath + "Assets/Fonts/OpenSansLight.ttf"
    }

    FontLoader {
        name: "Open Sans Regular";
        source: installPath + "Assets/Fonts/OpenSansRegular.ttf"
    }

    AuthUrlSubscription { }
}
