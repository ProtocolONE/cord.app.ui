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

        property int failCount: 0
        property string failDate: ""

        debug: false
        onConnected: {
            console.log('Centrifuge connected');
            centrifugeClient.startBatch();
            centrifugeClient.subscribe('qgna_zone_' + App.updateArea());

            centrifugeClient.subscribeUserChannel("user:private");
            centrifugeClient.subscribe("game:general");

//            for(var i = 0; i < 100; ++i) {
//                var chanelName = 'user_fake_channel_' + i;
//                centrifugeClient.subscribeUserChannel(chanelName);
//            }

            centrifugeClient.stopBatch();
        }

        onDisconnected: {
            console.log('Centrifuge disconnected');
        }

        onUserMessageReceived: {
            switch(channel) {
            case 'user:private':
                switch (params.type) {
                case 'balance_changed' :
                    User.balanceChangedByPush(params.args.balance);
                    console.log('new balance: ', params.args.balance)
                    break;
                }
                break;
            }
        }

        onMessageReceived: {
            switch(channel) {
            case 'game:general':
                switch (params.type) {
                case 'news_added' :
                    var gNews = WidgetManager.getWidgetByName("GameNews");
                    if (gNews && gNews.model) {
                        gNews.model.updateNewsByPush(params.args);
                        console.log('news added: ', JSON.stringify(params.args))
                    }
                    break;
                }
                break;
            }
        }

        onBeginReconnect: {
            if (tryCount == 4 || tryCount == 14) {
                Ga.trackException('Centrifugo reconnecting.  Try count ' + tryCount, false);
            }
        }
    }

    Component.onCompleted: centrifugeClient.debug = Config.GnUrl.debugApi();
}
