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
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    // Initialization
    Component.onCompleted: {
        Popup.init(popupLayer);

        WidgetManager.registerWidget('Application.Widgets.GameIsBoring');
        WidgetManager.init();
    }

    RequestServices {
            onReady: {
                var model = WidgetManager.getWidgetByName("GameIsBoring").model
                model.lastStoppedServiceId = "610000000000"
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
            text: "Show GameIsBoring!"

            onClicked: Popup.show("GameIsBoring");
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
