import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Components.Centrifugo 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    Connections {
        target: SignalBus

        onAuthDone: {
            var timestamp = (+Date.now()) + "";
            RestApi.Auth.getCentrifugoToken(timestamp, function(resp) {
                centrifugeClient.connect({
                                             timestamp: timestamp,
                                             user: User.userId(),
                                             token: resp.token,
                                             endpoint: resp.endpoint
                                         });
            });
        }

        onLogoutDone: {
            centrifugeClient.disconnect('logout');
        }
    }

    Centrifugo {
        id: centrifugeClient

        debug: false
        onConnected: {
            console.log('Centrifuge connected');
            centrifugeClient.startBatch();
            centrifugeClient.subscribeUserChannel("money");
            centrifugeClient.subscribeUserChannel("profile");
            centrifugeClient.subscribeUserChannel("notifications");
            centrifugeClient.stopBatch();
        }

        onDisconnected: {
            console.log('Centrifuge disconnected');
        }

        onUserMessageReceived: {
            switch(channel) {
            case 'money':
                console.log('new balance: ', params.balance)
                break;
            }
        }
    }

    Component.onCompleted: centrifugeClient.debug = Config.GnUrl.debugApi();
}
