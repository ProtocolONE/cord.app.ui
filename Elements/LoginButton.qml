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
import "." as Elements

Item {
    property string buttonText

    signal mouseClicked()

    width: 80
    height: 25

    Rectangle {
        anchors { fill: parent }
        border { width: 1; color: "#fff000" }
        color: '#00000000'
        opacity: 0.4
    }

    Rectangle {
        id: enterBox

        anchors { fill: parent; leftMargin: 1; topMargin: 1 }
        color: enterAction.containsMouse ? "#006600" : "#339900"

        Image {
            width: 16
            height: 18
            anchors { top: parent.top; left: parent.left; topMargin: 4; leftMargin: 6 }
            fillMode: Image.PreserveAspectFit
            source: installPath + "images/key.png"
        }

        Text {
            text: buttonText
            anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 30 }
            smooth: true
            font { family: "Arial"; pixelSize: 12 }
            color: "#fff"
        }
    }

    Elements.CursorMouseArea {
        id: enterAction

        anchors.fill: parent
        hoverEnabled: true
        onClicked: mouseClicked();
    }
}
