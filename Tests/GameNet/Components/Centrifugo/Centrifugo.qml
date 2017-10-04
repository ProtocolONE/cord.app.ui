import QtQuick 2.4
import QtQuick.Window 2.2

// INFO It's exports install path
import Dev 1.0

import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Components.Centrifugo 1.0

import Application 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Controls 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0
import Application.Blocks 1.0
import Application.Core.Authorization 1.0

Rectangle {
    id: root

    width: 1920
    height: 1080
    color: Styles.applicationBackground


    Component.onCompleted: {
        Config.show();

        Styles.init();
        Styles.setCurrentStyle('main');
        ContextMenu.init(contextMenuLayer);
        Tooltip.init(tooltipLayer);
        Popup.init(popupLayer);
        Moment.moment.lang('ru');

        MessageBox.init(messageLayer);

        d.initRestApi();

        WidgetManager.init();

        //MessengerJs.selectUser({ jid:  "qwe" })
    }

    QtObject {
        id: d

        function connectToGo() {
            var timestamp = "1506329181";
            RestApi.Auth.getCentrifugoToken(timestamp, function(resp) {
                console.log('---- token reponse', JSON.stringify(resp))
                centrifugeClient.connect({
                                             timestamp: timestamp,
                                             user: User.userId(),
                                             token: resp.token,
                                             endpoint: resp.endpoint
                                         });
            });

        }

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
                //d.authDone('400001000129602790', '2c1a900517acb61cc43d53b1d709889ff41af3cd'); // gna@unit.test sabirov.dev
                //d.authDone('400001000001634860', '4c2f65777d38eb07d32d111061005dcd5a119150'); // gna@unit.test gamenet.ru
                d.authDone('400001000129602790', '2c1a900517acb61cc43d53b1d709889ff41af3cd'); // gna@unit.test stg.gamenet.ru
                d.requestServices();
                d.connectToGo();
            }

            text: 'GnaUTest'
            onClicked: startAuth();
        }

        Button {
            text: "Close"
            onClicked:  {
                centrifugeClient.disconnect();
            }
        }

        Button {
            text: "Ping"
            onClicked:  {
                centrifugeClient.ping();
            }
        }


        Button {
            text: "fail"
            onClicked:  {
                console.log('---- call ping')
                centrifugeClient.callMethod('failMethod');
            }
        }


    }

    Centrifugo {
        id: centrifugeClient

        onConnected: {
            console.log('[Sample] connected');
            centrifugeClient.startBatch();
            centrifugeClient.subscribeUserChannel("money");
            centrifugeClient.subscribeUserChannel("profile");
            centrifugeClient.subscribeUserChannel("notifications");
            centrifugeClient.stopBatch();
        }

        onDisconnected: {
            console.log('[Sample] disconnected');
        }

        onMessageReceived: {
            console.log('[Sample] message: "' + channel + '"', JSON.stringify(params))
            switch(channel) {
            case 'money':
                console.log('new balance: ', params.balance)
                break;
            }
        }

        onUserMessageReceived: {
            console.log('[Sample] private message: "' + channel + '"', JSON.stringify(params))
            switch(channel) {
            case 'money':
                console.log('new balance: ', params.balance)
                break;
            }
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

