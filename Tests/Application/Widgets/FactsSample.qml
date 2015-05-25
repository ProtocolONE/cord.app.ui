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

import "../../../Application/Core/App.js" as App

Rectangle {
    width: 800
    height: 800

    color: '#002336'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Facts');
            manager.init();
        }
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("760"));
        }
    }

    WidgetContainer {
        widget: 'Facts'
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

        Button {
            width: 200
            height: 30

            text: "Activate 760 (REBORN)"
            onClicked: {
                App.activateGame(App.serviceItemByGameId("760"));
            }
        }
    }
}
