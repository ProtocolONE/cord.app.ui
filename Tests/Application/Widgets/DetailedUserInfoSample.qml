import QtQuick 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/Styles.js" as Styles
import "../../../Application/Core/moment.js" as Moment
import "../../../Application/Core/restapi.js" as RestApi

import "../../../GameNet/Controls/Tooltip.js" as Tooltip
import "../../../GameNet/Core/RestApi.js" as RestApiG

Item {
    id: root

    width: App.clientWidth
    height: App.clientHeight

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('mainStyle');
        Moment.moment.lang('ru');
        Tooltip.init(tooltipLayer);
    }

    QtObject {
        id: d

        function requestServices() {
            RestApi.Service.getUi(function(result) {
                App.fillGamesModel(result);
                App.setGlobalState("Authorization");
                App.openDetailedUserInfo({
                                             userId: "400001000000073060"
                                         });

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

    Timer {
        interval: 10
        running: true
        repeat: false
        onTriggered: d.startAuth();
            //App.openDetailedUserInfo("400001000000000230")
    }

    Rectangle  {
        anchors.fill: parent
        color: "black"
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.DetailedUserInfo');
            manager.init();
        }
    }

    Item {
        width: parent.width
        height: 42

        Row {
            anchors.fill: parent
            spacing: 10

            Button {
                width: 100
                height: 30
                text: 'Login'
                onClicked: d.startAuth();
            }

            Button {
                width: 100
                height: 30
                text: "Ilyatk"
                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000000073060"
                                                    })

            }

            Button {
                width: 100
                height: 30
                text: "test07"
                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000000000230"
                                                    })
            }

            Button {
                width: 100
                height: 30
                text: "Draxus"

                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000000000110"
                                                    })

            }

            Button {
                width: 100
                height: 30
                text: "Misterion"

                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000000065690"
                                                    })
            }

            Button {
                width: 100
                height: 30
                text: "tehnik19"

                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000000914120"
                                                    })
            }

            Button {
                width: 100
                height: 30
                text: "Nikita_K"


                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000029908410"
                                                    })

                //                onClicked: App.openDetailedUserInfo({
//                                                        userId //
//                                                        nickName // ну если есть
//                                                        status // текущий статус из джабера
//                                                        isFriend // web search
//                                                        isSended // web search
//                                                    });
            }


            Button {
                width: 100
                height: 30
                text: "gnaunittest77"

                onClicked: App.openDetailedUserInfo({
                                                        userId: "400001000037399840"
                                                    })
            }

            Button {
                width: 100
                height: 30
                text: "Close"

                onClicked: App.closeDetailedUserInfo()
            }
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
                    width: 353
                    widget: 'DetailedUserInfo'
                    view: 'DetailedUserInfo'
                }
            }

            Item {
                width: 230
                height: parent.height
            }
        }
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
    }

}
