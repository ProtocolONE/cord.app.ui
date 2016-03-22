/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Dev 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

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
