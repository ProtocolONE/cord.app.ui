import QtQuick 2.4
import Dev 1.0

import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0

Rectangle {
    width: 800
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameAdBanner');
            manager.init();
        }
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("92"));
        }
    }

    WidgetContainer {
        width: 590
        height: 150
        widget: 'GameAdBanner'
    }

    Row {
        x: 10
        y: 200
        spacing: 20

        Button {
            width: 200
            height: 30

            text: "Activate 92 (CA)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("92"));
            }
        }

        Button {
            width: 200
            height: 30

            text: "Activate 71 (BS)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("71"));
            }
        }
    }
}
