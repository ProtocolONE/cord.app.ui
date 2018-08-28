import QtQuick 2.4
import Dev 1.0
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Rectangle {
    width: 800
    height: 800
    color: '#002336'

    Component.onCompleted: {
        Moment.moment.lang('ru');

        WidgetManager.registerWidget('Application.Widgets.GameNews')
        WidgetManager.init()
    }

    RequestServices {
        onReady: App.activateGame(App.serviceItemByGameId("1067"))
    }

    Column {
        Row {
            x: 10
            y: 200
            spacing: 20

            Button {
                width: 200
                height: 30

                text: "Activate 92 (CA)"
                onClicked: App.activateGame(App.serviceItemByGameId("92"))
            }

            Button {
                width: 200
                height: 30

                text: "Activate 71 (BS)"
                onClicked: App.activateGame(App.serviceItemByGameId("71"))
            }
        }

        WidgetContainer {
            width: 590
            height: 500
            widget: 'GameNews'
        }
    }
}
