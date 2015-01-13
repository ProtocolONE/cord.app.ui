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

import GameNet.Controls 1.0
import Application.Blocks 1.0

import "Core/App.js" as App
import "Core/Styles.js" as Styles
import "Core/User.js" as User
import "Core/restapi.js" as RestApi
import "Core/Authorization.js" as Authorization
import "Core/Popup.js" as Popup
import "Core/MessageBox.js" as MessageBox
import "Core/TrayPopup.js" as TrayPopup

import "../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../GameNet/Controls/Tooltip.js" as Tooltip

Item {
    id: root

    anchors.fill: parent

    Component.onCompleted: init()

    function init() {
        var mainWindowInstance = App.mainWindowInstance();
        var options = {
            desktop: Desktop.screenWidth + 'x' + Desktop.screenHeight,
            defaultApiUrl: 'https://gnapi.com:8443/restapi'
        };

        Host.hwidChanged.connect(function(result) {
            var mid = Marketing.mid();
            console.log('Authorization use mid `' + mid + '`');
            Authorization.setup({ mid: mid, hwid: encodeURIComponent(result)});
            App.authAccepted = true;
        })

        Host.hwid(true);

        console.log('GameNet Application version ' + App.fileVersion() + ' starting up');
        console.log('Desktop', options.desktop);

        Styles.init();
        initRestApi(options);
        initGoogleAnalytics(options);
        initAdditionalLayers(options);

        if (mainWindowInstance) {
            mainWindowInstance.leftMousePress.connect(function(x,y) {
                App.leftMousePress(root, x, y);
            });

            mainWindowInstance.leftMouseRelease.connect(function(x,y) {
                App.leftMouseRelease(root, x, y);
            });

            mainWindowInstance.selectService.connect(function(serviceId) {
                if (!App.serviceExists(serviceId)) {
                    App.navigate('allgame')
                    return;
                }

                App.selectService(serviceId);
            });

            mainWindowInstance.needPakkanenVerification.connect(function() {
                App.needPakkanenVerification();
            });
        }
    }

    function initAdditionalLayers(options) {
        Popup.init(popupLayer);
        MessageBox.init(messageLayer);
        TrayPopup.init();
        Tooltip.init(tooltipLayer);
    }

    function initRestApi(options) {
        var url = Settings.value('qGNA/restApi', 'url', options.defaultApiUrl);

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
                                        App.logoutRequest();
                                       }
                                   }

                               }
                           });
    }

    function initGoogleAnalytics(options) {
        var gaSettings = {
            accountId: "UA-35280627-5",
            saveSettings: Settings.setValue,
            loadSettings: Settings.value,
            desktop: options.desktop,
            systemVersion: GoogleAnalyticsHelper.systemVersion(),
            globalLocale: GoogleAnalyticsHelper.systemLanguage(),
            applicationVersion: App.fileVersion()
        };

        GoogleAnalytics.init(gaSettings);

        var mid = Marketing.mid();
        if (!mid) {
            return;
        }

        RestApi.Marketing.getMidDetails(mid, function(response) {
            var midDescription = (response.agentId || "")
                    + '-' + (response.company || "")
                    + '-' + (response.urlId || "");

            GoogleAnalytics.setMidDescription(midDescription);
        });
    }

    function resetCredential() {
        CredentialStorage.reset();
    }

    function setAuthInfo(userId, appKey, cookie) {
        Settings.setValue("qml/auth/", "authDone", 1);
        App.authSuccessSlot(userId, appKey, cookie);
        User.setCredential(userId, appKey, cookie);
    }

    function requestServices() {
        RestApi.Service.getUI(function(result) {
            App.servicesList = result;
            App.fillGamesModel(result);
            App.setGlobalState("Authorization");
        }, function(result) {
            console.log('get services error', result);
            retryTimer.start();
        });
    }

    Timer {
        id: retryTimer

        property int count: 0

        function getInterval() {
          var timeout = [5, 10, 15, 20, 60];
          var index = (retryTimer.count >= timeout.length) ? (timeout.length - 1) : retryTimer.count;
          retryTimer.count += 1;
          return timeout[index] * 1000;
        }

        interval: getInterval()
        onTriggered: d.requestServices();
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
        target: App.signalBus();

        ignoreUnknownSignals: true

        onLogoutRequest: {
            App.logout();
            root.resetCredential();
            App.logoutDone();
        }

        onLogoutDone: {
            App.setGlobalState('Authorization');
            GoogleAnalytics.userId = null;
        }

        onAuthDone: {
            root.setAuthInfo(userId, appKey, cookie);
            GoogleAnalytics.userId = userId;
            GoogleAnalytics.activate();
            App.setGlobalState('Application');
        }

        onSetGlobalProgressVisible: {
            globalProgressLock.interval = (timeout && value) ? timeout : 500;
            globalProgressLock.visible = value;
        }

        onUpdateFinished: {
            root.requestServices();
        }
    }

    Connections {
        target: App.mainWindowInstance()
        onNavigate: App.navigate(page);
        onWrongCredential: {
            if (userId === User.userId()) {
                App.logoutRequest()
            }
        }
    }
}
