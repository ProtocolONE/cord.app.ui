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
            //  INFO: пока такой способ скрыть формы настроек при
            //  нажатии на остальные кнопки меню
            root.state = "";
        }
        onOpenGameSettings: {
            root.state = "GameSettings";
        }
        onOpenApplicationSettings: {
            root.state = "ApplicationSettings";
        }
    }
    
    GameSettings {
        id: gameSettings

        width: parent.width
        height: 558
        anchors.bottom: parent.bottom
        visible: false

        onAccepted: root.state = "";
    }

    ApplicationSettings {
        id: applicationSettings

        width: parent.width
        height: 558
        anchors.bottom: parent.bottom
        visible: false

        onAccepted: root.state = "";
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
