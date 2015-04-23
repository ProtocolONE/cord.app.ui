/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Components.JobWorker 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/TrayPopup.js" as TrayPopup
import "../../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs
import "../../../Application/Core/moment.js" as Moment
import "../../../Application/Core/Styles.js" as Styles
import "../../../Application/Core/restapi.js" as RestApi
import "../../../Application/Core/EmojiOne.js" as EmojiOne
import "../../../Application/Core/User.js" as UserJs
import "../../../Application/Core/MessageBox.js" as MessageBox

import "../../../GameNet/Core/lodash.js" as Lodash
import "../../../GameNet/Core/RestApi.js" as RestApiG
import "../../../GameNet/Controls/Tooltip.js" as Tooltip
import "../../../GameNet/Controls/ContextMenu.js" as ContexMenu

import "./Messenger/Logger.js" as Logger

import "../../../Application/Widgets/Messenger/View/Styles"

Rectangle {
    id: root

    function initEmojiOne() {
        if (App.isQmlViewer()) {
            EmojiOne.ns.imagePathPNG = (installPath + 'Develop/Assets/Smiles/').replace("file:///", ""); // Debug for QmlViewer
        } else {
            EmojiOne.ns.imagePathPNG = ':/Develop/Assets/Smiles/';
        }

        EmojiOne.ns.ascii = true;
        EmojiOne.ns.unicodeAlt = false;
        EmojiOne.ns.cacheBustParam = "";
        EmojiOne.ns.addedImageProps = '"width"= "20" height"="20"'
    }

    width: 1000
    height: 600
    color: '#EEEEEE'

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('mainStyle');
        TrayPopup.init();
        root.initEmojiOne();
        ContexMenu.init(contextMenuLayer);
        Tooltip.init(tooltipLayer);
        Moment.moment.lang('ru');

        Logger.init(MessengerJs.dataModel.client);

        MessageBox.init(messageLayer);

        d.initRestApi();
        //MessengerJs.selectUser({ jid:  "qwe" })
    }

    QtObject {
        id: d

        function requestServices() {
            RestApi.Service.getUi(function(result) {
                App.fillGamesModel(result);
                App.setGlobalState("Authorization");
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
            RestApiG.Core.setUserId(userId);
            RestApiG.Core.setAppKey(appKey);
            RestApi.Core.setUserId(userId);
            RestApi.Core.setAppKey(appKey);

            App.authDone(userId, appKey);
        }
    }

    Row {
        spacing: 10

        Button {
            function startAuth() {
                //d.authDone('400001000005869460', 'fac8da16caa762f91607410d2bf428fb7e4b2c5e'); //0 friends
                //d.authDone('400001000000065690', 'cd34fe488b93d254243fa2754e86df8ffbe382b9'); //300+ friends
                //d.authDone('400001000000000110', '6c5f39adaaa18c3b4a6d8f4af5289ecf76029af2'); //800+ friends
                //d.authDone('400001000000073060', '6f2d51fcb4fbc0db43e02c5b855ef1f10f9d5a75'); //3600+ friends
                //d.authDone('400001000005959640', '1123cf8d91aabb9ebc8345def6a13772cc020498');
                //d.authDone('400001000001709240', '570e3c3e59c7c4d7a1b322a0e25f231752814dc6'); // gna2@unit.test
                //d.authDone('400001000030060540', '23c936940e97a2972e55947c9f63e3471583972c'); //300+ friends

                //d.authDone('400001000002212660', '04b47ad21518058fa9d441a6d50abdfa2d21e252'); // gna3@unit.test
                d.authDone('400001000001709240', '570e3c3e59c7c4d7a1b322a0e25f231752814dc6'); // gna2@unit.test
                //d.authDone('400001000001634860', '4c2f65777d38eb07d32d111061005dcd5a119150');

                d.requestServices();
            }

            enabled: !MessengerJs.authedUser().jid
            width: 100
            height: 30
            text: 'Master 02'
            onClicked: startAuth();
        }

        Button {
            function startAuth2() {
                //d.authDone('400001000005869460', 'fac8da16caa762f91607410d2bf428fb7e4b2c5e'); //0 friends
                //d.authDone('400001000000065690', 'cd34fe488b93d254243fa2754e86df8ffbe382b9'); //300+ friends
                //d.authDone('400001000000000110', '6c5f39adaaa18c3b4a6d8f4af5289ecf76029af2'); //800+ friends
                //d.authDone('400001000000073060', '6f2d51fcb4fbc0db43e02c5b855ef1f10f9d5a75'); //3600+ friends
                //d.authDone('400001000005959640', '1123cf8d91aabb9ebc8345def6a13772cc020498');
                //d.authDone('400001000001709240', '570e3c3e59c7c4d7a1b322a0e25f231752814dc6'); // gna2@unit.test
                //d.authDone('400001000030060540', '23c936940e97a2972e55947c9f63e3471583972c'); //300+ friends

                d.authDone('400001000002212660', '04b47ad21518058fa9d441a6d50abdfa2d21e252'); // gna3@unit.test
                //d.authDone('400001000001709240', '570e3c3e59c7c4d7a1b322a0e25f231752814dc6'); // gna2@unit.test
                //d.authDone('400001000001634860', '4c2f65777d38eb07d32d111061005dcd5a119150');

                d.requestServices();
            }

            enabled: !MessengerJs.authedUser().jid
            width: 100
            height: 30
            text: '8Alex8'
            onClicked: startAuth2();
        }

        Button {
            function startAuth3() {
                //d.authDone('400001000005869460', 'fac8da16caa762f91607410d2bf428fb7e4b2c5e'); //0 friends
                //d.authDone('400001000000065690', 'cd34fe488b93d254243fa2754e86df8ffbe382b9'); //300+ friends
                //d.authDone('400001000000000110', '6c5f39adaaa18c3b4a6d8f4af5289ecf76029af2'); //800+ friends
                //d.authDone('400001000000073060', '6f2d51fcb4fbc0db43e02c5b855ef1f10f9d5a75'); //3600+ friends
                //d.authDone('400001000005959640', '1123cf8d91aabb9ebc8345def6a13772cc020498');
                //d.authDone('400001000001709240', '570e3c3e59c7c4d7a1b322a0e25f231752814dc6'); // gna2@unit.test
                //d.authDone('400001000030060540', '23c936940e97a2972e55947c9f63e3471583972c'); //300+ friends

                //d.authDone('400001000002212660', '04b47ad21518058fa9d441a6d50abdfa2d21e252'); // gna3@unit.test
                //d.authDone('400001000001709240', '570e3c3e59c7c4d7a1b322a0e25f231752814dc6'); // gna2@unit.test
                //d.authDone('400001000001634860', '4c2f65777d38eb07d32d111061005dcd5a119150');

                d.authDone('400001000002837740', 'e46bbb8616670c79dabaa963f0d29fe08d100685'); // gna4@unit.test

                d.requestServices();
            }

            enabled: !MessengerJs.authedUser().jid
            width: 100
            height: 30
            text: 'Iuan'
            onClicked: startAuth3();
        }

        Button {
            width: 100
            height: 30
            text: 'Logout'
            onClicked: App.logoutDone();
        }

        Button {
            width: 100
            height: 30
            text: 'Disconnect'
            onClicked: MessengerJs.disconnect();
        }

        Button {
            width: 100
            height: 30
            text: 'Start Play'
            onClicked: {
                var game = App.serviceItemByGameId("71");
                game.status = "Started";
                App.serviceStarted(game);
            }
        }

        Button {
            width: 100
            height: 30
            text: 'Stop Play'
            onClicked: {
                var game = App.serviceItemByGameId("71");
                game.status = "Normal";
                App.serviceFinished(game);
            }
        }
    }

    JobWorker {
        id: worker

        interval: 100
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.UserProfile');
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.DetailedUserInfo');
            manager.registerWidget('Application.Widgets.AlertAdapter');
            manager.init();
        }
    }

    Item {
        anchors { fill: parent;  topMargin: 42 }

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width: 180

                Column {
                    anchors.fill: parent
                    spacing: 10

                }
            }

            Item {
                height: parent.height
                width: 590

                WidgetContainer {
                    height: parent.height
                    width: 590
                    widget: 'Messenger'
                    view: 'Chat'
                }

                WidgetContainer {
                    height: parent.height
                    width: 353
                    widget: 'DetailedUserInfo'
                    view: 'DetailedUserInfo'
                }
            }

            Column {
                width: 230
                height: parent.height

                Rectangle {
                    width: parent.width
                    height: 92
                    color: "#243148"

                    WidgetContainer {
                        width: 229
                        height: 92
                        widget: 'UserProfile'
                    }
                }

                WidgetContainer {
                    height: parent.height - 91
                    width: 230
                    widget: 'Messenger'
                    view: 'Contacts'
                }
            }
        }
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
