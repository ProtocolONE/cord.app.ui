import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0
import Tests.Application.Core.Fixtures.Popup.Sample 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

Item {
    width: 1000
    height: 599

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.AlertAdapter');
            manager.registerWidget('Application.Widgets.Maintenance');
            manager.registerWidget('Application.Widgets.Facts');
            manager.registerWidget('Tests.Application.Core.Fixtures.Popup.Sample');
            manager.init();

            AppJs.activateGame(AppJs.serviceItemByGameId("92"));
        }
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
        id: messageBoxLayer

        anchors.fill: parent
        z: 3
    }

    // Initialization

    Component.onCompleted: {
        Popup.init(popupLayer);
        MessageBox.init(messageBoxLayer);
    }

    // Test Buttons

    Row {
        z: 3

        spacing: 3

        Button {
            width: 200
            height: 30

            text: "Maintenance"

            onClicked: Popup.show("Maintenance");
        }

        Button {
            width: 200
            height: 30

            text: "Facts"

            onClicked: Popup.show("Facts");
        }

        Button {
            width: 200
            height: 30

            text: "SomeWidget"

            onClicked: Popup.show("Sample");
        }

        Button {
            width: 200
            height: 30

            text: "SomeWidget (priority 1)"

            onClicked: Popup.show("Sample", undefined, 1);
        }

        Button {
            width: 200
            height: 30

            text: "MessageBox"

            onClicked: MessageBox.show("этот очень замечательный заголовок",
                                        "Какой то очень длинный длинный текст раз два три четыре, я ты он она, вместе дружная семья!",
                                        MessageBox.button["ok"] | MessageBox.button["cancel"] | MessageBox.button["yes"], function(result) {
             });

        }
    }
}
