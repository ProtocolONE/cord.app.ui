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

import "Core/App.js" as AppJs
import "Core/GoogleAnalytics.js" as GoogleAnalytics
import "Core/restapi.js" as RestApi
import "Core/Authorization.js" as Authorization

Item {
    id: root

    visible: false
    Component.onCompleted: init()

    function init() {
        var options = {
            desktop: Desktop.screenWidth + 'x' + Desktop.screenHeight,
            defaultApiUrl: 'https://gnapi.com:8443/restapi'
        };

        App.hwidChanged.connect(function(result) {
            var mid = Marketing.mid();
            console.log('Authorization use mid `' + mid + '`');
            Authorization.setup({ mid: mid, hwid: encodeURIComponent(result)});
            AppJs.authAccepted = true;
        })

        App.hwid(true);

        console.log('GameNet Application version ' + AppJs.fileVersion() + ' starting up');
        console.log('Desktop', options.desktop);

        initRestApi(options);
        initGoogleAnalytics(options);

        updateInstallDate();
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
            applicationVersion: AppJs.fileVersion()
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
        var installDate = AppJs.installDate();
        if (!installDate) {
            AppJs.setInstallDate();
            var startingServiceId = AppJs.startingService() || "0";
            if (!!startingServiceId && startingServiceId != "0") {
                Settings.setValue('qGNA', 'installWithService', startingServiceId);
            }
        }
    }

    function resetCredential() {
        CredentialStorage.reset();
    }

    function setAuthInfo() {
        Settings.setValue("qml/auth/", "authDone", 1);
    }

    Connections {
        target: AppJs.signalBus();

        ignoreUnknownSignals: true
        // ### TODO по хорошему это не должно быть тут

        onLogoutRequest: {
            AppJs.logout();
            root.resetCredential();
            AppJs.logoutDone();
        }

        onLogoutDone: {
            AppJs.setGlobalState('Authorization');
        }

        onAuthDone: {
            root.setAuthInfo();
            AppJs.setGlobalState('ServiceLoading');
        }
    }
}
