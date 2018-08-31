import QtQuick 2.4
import Dev 1.0
import Tulip 1.0

import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    // Initialization
    Component.onCompleted: {
        Popup.init(popupLayer);
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameFailed');
            manager.init();

            App.activateGame(App.serviceItemByGameId("92"));
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }

        Button {
            x: 400
            y: 400
            width: 200
            height: 20
            text: "Show GameFailed!"

            onClicked: Popup.show("GameFailed");
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
