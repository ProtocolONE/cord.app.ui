import QtQuick 2.4

import GameNet.Core 1.0
import Application.Core 1.0

Item {
    id: d

    signal ready();

    Component.onCompleted: {
        d.authDone('400001000002837740', 'e46bbb8616670c79dabaa963f0d29fe08d100685'); // gna4@unit.test
        d.requestServices();
    }

    function requestServices() {
        RestApi.Service.getUi(function(result) {
            App.fillGamesModel(result);
            SignalBus.setGlobalState("Authorization");

            d.ready();
        }, function(result) {
            console.log('get services error', result);
            retryTimer.start();
        });
    }

    function initRestApi(options) {
        RestApi.Core.setup({
                               lang: 'ru',
                               genericErrorCallback: function(code, message) {
                                   if (code == RestApi.Error.AUTHORIZATION_FAILED
                                       || code == RestApi.Error.ACCOUNT_NOT_EXISTS
                                       || code == RestApi.Error.AUTHORIZATION_LIMIT_EXCEED
                                       || code == RestApi.Error.UNKNOWN_ACCOUNT_STATUS) {
                                       console.log('RestApi generic error', code, message);
                                   }

                               }
                           });
    }

    function authDone(userId, appKey) {
        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        SignalBus.authDone(userId, appKey, "");
    }
}
