/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import Application.Blocks 1.0

import "../Core/App.js" as App

Item {
    id: root

    Connections {
        target: App.signalBus()

        onNavigate: {
            if (link == 'ApplicationSettings' || link == 'GameSettings') {
                root.state = link;
                return;
            }

            //  INFO: пока такой способ скрыть формы настроек при
            //  нажатии на остальные кнопки меню
            root.state = "";
        }
    }

    GameSettings {
        id: gameSettings

        width: parent.width
        height: 570
        anchors.bottom: parent.bottom
        visible: false

        onClose: root.state = "";
    }

    ApplicationSettings {
        id: applicationSettings

        width: parent.width
        height: 570
        anchors.bottom: parent.bottom
        visible: false

        onClose: root.state = "";
    }

    states: [
        State {
            name: "GameSettings"

            PropertyChanges { target: gameSettings; visible: true}
        },
        State {
            name: "ApplicationSettings"

            PropertyChanges { target: applicationSettings; visible: true}
        }
    ]
}
