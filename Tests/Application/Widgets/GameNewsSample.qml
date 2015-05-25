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
import GameNet.Controls 1.0

import "../../../Application/Core/moment.js" as Moment
import "../../../Application/Core/App.js" as App

Rectangle {
    width: 800
    height: 800
    color: '#002336'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            Moment.moment.lang('ru');

            manager.registerWidget('Application.Widgets.GameNews')
            manager.init()
            App.activateGame(App.serviceItemByGameId("92"))
        }
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
