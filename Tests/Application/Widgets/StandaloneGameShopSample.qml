import QtQuick 2.4
import Dev 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

import Application.Core.Authorization 1.0

import QtWebSockets 1.0

Rectangle {
    width: App.clientWidth
    height: App.clientHeight
    color: '#AAAAAA'

    Item {
        id: initManager

        signal servicesFinished();

        function requestServices() {
            RestApi.Service.getUi(function(result) {
                App.fillGamesModel(result);
                SignalBus.setGlobalState("Authorization");

                initManager.servicesFinished();
            }, function(result) {
                console.log('get services error', result);
            });
        }

        function genericAuth(login, password, done) {
            Authorization.loginByGameNet(login, password, false, function(error, response) {
                if (!Authorization.isSuccess(error)) {
                    console.log('Auth failed!')
                    return;
                }

                RestApi.Core.setUserId(response.userId);
                RestApi.Core.setAppKey(response.appKey);

                SignalBus.authDone(response.userId, response.appKey, response.cookie);
                App.authSuccessSlot(response.userId, response.appKey, response.cookie);
                User.setCredential(response.userId, response.appKey, response.cookie);

                if (done) {
                    done();
                }
            });
        }

        function authDone() {
            initManager.requestServices();
        }

        onServicesFinished: {
            openUrlButton.enabled = true;
        }

        Component.onCompleted: {
            RestApi.Core.setup({
                                   lang: 'ru',
                                   //url: "http://api.tkachenko.dev/restapi"
                                   url: 'https://gnapi.com:8443/restapi'
                               });

            WidgetManager.registerWidget('Application.Widgets.StandaloneGameShop');
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');

            WidgetManager.init();

            Popup.init(popupLayer);
            MessageBox.init(messageBoxLayer);

            //Authorization._gnLoginUrl = 'http://gnlogin.tkachenko.dev';
            genericAuth('gna@unit.test', '123456', initManager.authDone);
        }
    }

    Row {
        spacing: 10

        Button {
            id: openUrlButton

            enabled: false
            text: "30000000000"

            onClicked: {
                SignalBus.buyGame("30000000000");
            }
        }
    }

    WidgetContainer {
        id: widget

        x: 182
        y: 115
        width: 1770
        height: 758
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }

    Item {
        id: messageBoxLayer

        anchors.fill: parent
    }

    GlobalProgress {
        id: globalProgressLock

        showWaitImage: false
        maxOpacity: 0.25
        anchors.fill: parent
    }

    Connections {
        target: SignalBus

        onSetGlobalProgressVisible: {
            globalProgressLock.interval = (timeout && value) ? timeout : 500;
            globalProgressLock.visible = value;
        }
    }

}
