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
    color: '#EEEEEE'

    // Initialization
    Component.onCompleted: {
        Popup.init(popupLayer);

        WidgetManager.registerWidget('Application.Widgets.GameAdBanner');
        WidgetManager.registerWidget('Application.Widgets.GameInfo');
        WidgetManager.registerWidget('Application.Widgets.GameExecuting');
        WidgetManager.init();
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("92"));
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            console.log("Closed popupId: " + popupId);
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
            x: 10
            y: 98
            width: 160
            height: 36
            text: 'Начать игру'
            onClicked: Popup.show('GameExecuting');
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
