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

import "Core/App.js" as App
import "Core/User.js" as User
import "Core/GoogleAnalytics.js" as GoogleAnalytics
import "Core/restapi.js" as RestApi

import "Core/Popup.js" as Popup
import "Core/MessageBox.js" as MessageBox
import "Core/TrayPopup.js" as TrayPopup

Item {
    id: root

    anchors.fill: parent

    Component.onCompleted: init()

    function init() {
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

        initRestApi(options);
        initGoogleAnalytics(options);
        initAdditionalLayers(options);

        updateInstallDate();

        if (mainWindow) {
            mainWindow.leftMouseClick.connect(function(x,y) {
                App.leftMouseClick(root, x, y);
            });

            mainWindow.selectService.connect(function(serviceId) {
                App.selectService(serviceId);
            });

            mainWindow.needPakkanenVerification.connect(function() {
                App.needPakkanenVerification();
            });
        }
    }

    function initAdditionalLayers(options) {
        Popup.init(popupLayer);
        MessageBox.init(messageLayer);
        TrayPopup.init();
    }

    function initRestApi(options) {
        var url = Settings.value('qGNA/restApi', 'url', options.defaultApiUrl);

        console.log('RestApi use', url);
        RestApi.Core.setup({lang: 'ru', url: url});
    }

    function initGoogleAnalytics(options) {
        var gaSettings = {
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

    function updateInstallDate() {
        var installDate = App.installDate();
        if (!installDate) {
            App.setInstallDate();
            var startingServiceId = App.startingService() || "0";
            if (!!startingServiceId && startingServiceId != "0") {
                Settings.setValue('qGNA', 'installWithService', startingServiceId);
            }
        }
    }

    function resetCredential() {
        CredentialStorage.reset();
    }

    function setAuthInfo(userId, appKey, cookie) {
        Settings.setValue("qml/auth/", "authDone", 1);
        App.authSuccessSlot(userId, appKey, cookie);
        User.setCredential(userId, appKey, cookie);
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }

    Item {
        id: messageLayer

        anchors.fill: parent
    }

    Tooltip {
        onLinkActivated: App.openExternalUrl(link);
    }

    GlobalProgress {
        id: globalProgressLock

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
        }

        onAuthDone: {
            root.setAuthInfo(userId, appKey, cookie);
            App.setGlobalState('ServiceLoading');
        }

        onSetGlobalProgressVisible: {
            globalProgressLock.interval = (timeout && value) ? timeout : 500;
            globalProgressLock.visible = value;
        }
    }
}
