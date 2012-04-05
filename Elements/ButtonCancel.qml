/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0
import "." as Elements

Item {
    property string buttonText;

    signal buttonPressed();

    height: 27
    width: 70

    Rectangle {
        anchors.fill: parent
        color: buttonMouseArea.containsMouse ? "#006600" : "#00000000"
        opacity: buttonMouseArea.containsMouse ? 1 : 0.7
        border.color: "#fff"
    }

    Text {
        x: 24
        y: 7
        text: buttonText
        font { family: fontTahoma.name; weight: "Light"; pixelSize: 16; bold: false }
        color: "#ffffff"
        opacity: buttonMouseArea.containsMouse ? 1 : 0.7
        anchors { centerIn: parent }
    }

    Elements.CursorMouseArea {
        id: buttonMouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: buttonPressed()
    }
}
