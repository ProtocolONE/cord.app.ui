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

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/TrayPopup.js" as TrayPopup
import "../../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs
import "../../../Application/Core/moment.js" as Moment
import "../../../Application/Core/Styles.js" as Styles
import "../../../Application/Core/restapi.js" as RestApi
import "../../../Application/Core/EmojiOne.js" as EmojiOne

import "../../../GameNet/Core/lodash.js" as Lodash
import "../../../GameNet/Core/RestApi.js" as RestApiG
import "../../../GameNet/Controls/Tooltip.js" as Tooltip

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
        Tooltip.init(tooltipLayer);
        Moment.moment.lang('ru');
    }

    Row {
        spacing: 10

        Button {
            function requestServices() {
                RestApi.Service.getUi(function(result) {
                    App.fillGamesModel(result);
                    App.setGlobalState("Authorization");
                }, function(result) {
                    console.log('get services error', result);
                    retryTimer.start();
                });
            }

            function startAuth() {
                //App.authDone('400001000005869460', 'fac8da16caa762f91607410d2bf428fb7e4b2c5e'); //0 friends
                App.authDone('400001000000065690', 'cd34fe488b93d254243fa2754e86df8ffbe382b9'); //300+ friends
                //App.authDone('400001000000000110', 'acf2f89b60dfe4eddc1b7a1cbdaf0d737d0a5311'); //800+ friends
                //App.authDone('400001000000073060', '6f2d51fcb4fbc0db43e02c5b855ef1f10f9d5a75'); //3600+ friends
                //App.authDone('400001000005959640', '1123cf8d91aabb9ebc8345def6a13772cc020498');



                requestServices();
            }

            width: 100
            height: 30
            text: 'Login'
            onClicked: startAuth();
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
            text: 'Refresh'
            onClicked: {
//                var groupId = "FireStorm (FS)";
//                var users = MessengerJs.groups().getById(groupId).users;
//                for (var i = 0; i < users.count; i++) {
//                    MessengerJs.users().removeById(users.get(i).jid);
//                }

//                MessengerJs.groups().removeById(groupId);
                //MessengerJs._modelInstance.rosterReceived();
                MessengerJs._modelInstance.hack();
            }
        }

        Button {
            width: 100
            height: 30
            text: 'del user'
            onClicked: {
//                var groupId = "Combat Arms (CA)";
//                var users = MessengerJs.groups().getById(groupId).users;
//                var index = users.count > 5 ? 5 : Math.floor(users.count / 2)
//                users.remove(index);
                MessengerJs.users().remove(0);
                //MessengerJs.groups().endBatch();
                MessengerJs.users().endBatch();
            }
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

        Button {
            width: 100
            height: 30
            text: 'Feed'
            onClicked: {
//                console.log('---- push');
//                var item = {};
//                item.x = 5;
//                item.start = Date.now();
//                item.execute = function() {
//                    console.log(Date.now(), this.x, this.start);
//                    this.x--;
//                    return this.x === 0;
//                }

//                worker.push(item);
            }
        }
    }

    Connections {
        target: App.signalBus()
        onAuthDone: {
            RestApiG.Core.setUserId(userId);
            RestApiG.Core.setAppKey(appKey);
            RestApi.Core.setUserId(userId);
            RestApi.Core.setAppKey(appKey);
        }
    }

    JobWorker {
        id: worker

        interval: 100
    }


    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.DetailedUserInfo');
            manager.init();
        }
    }

    Item {
        anchors { fill: parent;  topMargin: 42}

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width: 180
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
                    height: 91
                    color: "#243148"
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
        id: tooltipLayer

        anchors.fill: parent
    }
}
