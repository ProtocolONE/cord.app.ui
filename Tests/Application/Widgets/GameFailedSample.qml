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
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/App.js" as App

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    // Initialization
    Component.onCompleted: {
        Settings.setValue("qml/core/popup/", "isHelpShowed", 0);
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
