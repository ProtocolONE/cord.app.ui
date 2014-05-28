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

import "../../../js/Core.js" as CoreJs

Rectangle {
    width: 800
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameAdBanner');
            manager.init();
            CoreJs.activateGame(CoreJs.serviceItemByGameId("92"));
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
                CoreJs.activateGame(CoreJs.serviceItemByGameId("92"));
            }
        }

        Button {
            width: 200
            height: 30

            text: "Activate 71 (BS)"
            onClicked: {
                CoreJs.activateGame(CoreJs.serviceItemByGameId("71"));
            }
        }
    }
}