import QtQuick 2.4

import Dev 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Controls 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0
import Application.Blocks 1.0
import Application.Core.Authorization 1.0
import Application.Core.Settings 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    Component.onCompleted: {
        Config.show();

        Styles.init();
        Styles.setCurrentStyle('main');
        ContextMenu.init(contextMenuLayer);
        Tooltip.init(tooltipLayer);
        Popup.init(popupLayer);
        Moment.moment.lang('ru');

        MessageBox.init(messageLayer);

        WidgetManager.registerWidget('Application.Widgets.ApplicationSettings');
        WidgetManager.registerWidget('Application.Widgets.Centrifugo');
        WidgetManager.init();

        d.initRestApi();
    }

    QtObject {
        id: d

        function requestServices() {
            RestApi.Service.getUi(function(result) {
                App.fillGamesModel(result);
                SignalBus.setGlobalState("Authorization");
            }, function(result) {
                console.log('get services error', result);
                retryTimer.start();
            });
        }

        function initRestApi(options) {
            var url = Config.GnUrl.api();
            if (!Config.GnUrl.overrideApi()) {
                url = AppSettings.value('qGNA/restApi', 'url', url);
            }

            RestApi.Core.setup({
                                   lang: 'ru',
                                   url: url,
                                   genericErrorCallback: function(code, message) {
                                       if (code == RestApi.Error.AUTHORIZATION_FAILED
                                           || code == RestApi.Error.ACCOUNT_NOT_EXISTS
                                           || code == RestApi.Error.AUTHORIZATION_LIMIT_EXCEED
                                           || code == RestApi.Error.UNKNOWN_ACCOUNT_STATUS) {
                                           console.log('RestApi generic error', code, message);
                                       }

                                   }
                               });

//            if (Config.GnUrl.debugApi()) {
//                RestApi.http.logRequest = true;
//            }
        }

        function authDone(userId, appKey) {
            console.log('userid = ' + userId);
            RestApi.Core.setUserId(userId);
            RestApi.Core.setAppKey(appKey);
            User.setCredential(userId, appKey, "");
            SignalBus.authDone(userId, appKey, "");
        }
    }

    Row {
        spacing: 10

        Button {
            function startAuth() {
                d.authDone('400001000129602790', '2c1a900517acb61cc43d53b1d709889ff41af3cd'); // gna@unit.test sabirov.dev
                //d.authDone('400001000001634860', '4c2f65777d38eb07d32d111061005dcd5a119150'); // gna@unit.test gamenet.ru
                //d.authDone('400001000129602790', '2c1a900517acb61cc43d53b1d709889ff41af3cd'); // gna@unit.test stg.gamenet.ru
                d.requestServices();
                //connectToGo();
            }

            text: 'GnaUTest'
            onClicked: startAuth();
        }

        Button {
            text: 'Logout'
            onClicked: SignalBus.logoutDone();
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: contextMenuLayer

        anchors.fill: parent
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
    }

    Item {
        id: messageLayer

        anchors.fill: parent
    }
}
