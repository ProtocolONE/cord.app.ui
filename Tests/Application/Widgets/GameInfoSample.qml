import QtQuick 2.4
import Dev 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0

Rectangle {
    width: 800
    height: 800
    color: '#cccccc'

    Component.onCompleted:  {
        WidgetManager.registerWidget('Application.Widgets.Facts');
        WidgetManager.registerWidget('Application.Widgets.GameInfo');
        WidgetManager.init();
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("1067"));
        }
    }

    WidgetContainer {
        x: 50
        y: 50
        widget: 'GameInfo'
    }

    Row {
        x: 10
        y: 600
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

        Button {
            width: 200
            height: 30

            text: "Activate 1067 (IS Defense)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("1067"));
            }
        }
    }
}
