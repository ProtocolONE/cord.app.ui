import QtQuick 2.4
import Tulip 1.0

import Dev 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Tests.Application.Core.Fixtures.Popup.Sample 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

import "../Widgets"

Item {
    width: 1000
    height: 599

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("92"));
        }
    }

    Component.onCompleted: {
        WidgetManager.registerWidget('Application.Widgets.Maintenance');
        WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
        WidgetManager.registerWidget('Application.Widgets.Facts');
        WidgetManager.registerWidget('Tests.Application.Core.Fixtures.Popup.Sample');
        WidgetManager.init();

        Popup.init(popupLayer);
        MessageBox.init(messageboxLayer);
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageboxLayer

        anchors.fill: parent
        z: 3
    }

    // Test Buttons
    Row {
        z: 3

        spacing: 3

        Button {
            width: 100
            height: 30

            text: "MBox 0"

            onClicked: {
                console.log("Show MBox 0");

                MessageBox.show("title", "message", MessageBox.button["ok"], function() {
                    MessageBox.show("title 2", "Tresumed imperatively.");
                });
            }
        }

        Button {
            width: 100
            height: 30

            text: "MBox 1"

            onClicked: {
                console.log("Show MBox 1");
                MessageBox.show("Электросталилетейный завод, череззаборногузадерищенко",
                                "<a href=\"http://ya.ru\">KB_495 </a> <br /> This property holds whether the animation is currently paused. The paused property can be set to declaratively control whether or not an animation is paused. Animations can also be paused and resumed imperatively. This property holds whether the animation is currently paused. The paused property can be set to declaratively control whether or not an animation is paused. Animations can also be paused and resumed imperatively.",
                                       MessageBox.button.ok | MessageBox.button.help | MessageBox.button.no, function(result) {

                                           console.log('MBox 1 result', result);
                });
            }
        }

        Button {
            width: 150
            height: 30

            text: "MBox 2"

            onClicked: MessageBox.show("Название диалогового окна",
                                       "Какой то очень длинный длинный текст раз два три четыре, я ты он она, вместе дружная семья!",
                                       MessageBox.button["ok"], function(result) {
            });
        }

        Button {
            width: 100
            height: 30

            text: "MBox 3"

            onClicked: MessageBox.show("этот очень замечательный заголовок",
                                       "Какой то очень длинный длинный текст раз два три четыре, я ты он она, вместе дружная семья!",
                                       MessageBox.button["ok"] | MessageBox.button["cancel"] | MessageBox.button["yes"], function(result) {
            });
        }

        Button {
            width: 100
            height: 30

            text: "Maintenance"

            onClicked: Popup.show("Maintenance");
        }

        Button {
            width: 100
            height: 30

            text: "Facts"

            onClicked: Popup.show("Facts");
        }

        Button {
            width: 150
            height: 30

            text: "SomeWidget"

            onClicked: Popup.show("Sample");
        }

        Button {
            width: 150
            height: 30

            text: "SWidget(priority 1)"

            onClicked: Popup.show('Sample', undefined, 1);
        }
    }
}
