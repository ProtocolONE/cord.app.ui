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
    width: 58
    height: 58

    anchors { top: parent.top; right: parent.right }
    visible: true

    property string buttonText;
    signal mouseClicked();

    Rectangle {
        anchors.fill: parent
        color: "#fff"
        opacity: 0.4
    }

    Rectangle {
        id: enterBox

        width: 56
        height: 56
        anchors {left: parent.left; leftMargin: 1; top: parent.top; topMargin: 1;}
        color: enterAction.containsMouse ? "#006600" : "#339900"

        Image {
            width: 30
            height: 32
            anchors { top: parent.top; topMargin: 6; horizontalCenter: parent.horizontalCenter }
            fillMode: Image.Tile
            source: installPath + "images/i_key.png"
        }

        Text {
            color: "#fff"
            text: buttonText;
            anchors { bottom: parent.bottom; bottomMargin: 2; horizontalCenter: parent.horizontalCenter }
            wrapMode: Text.NoWrap
            style: Text.Normal
            font { family: "Arial"; pixelSize: 12 }
        }
    }

    Elements.CursorMouseArea {
        id: enterAction

        anchors.fill: parent
        hoverEnabled: true
        onClicked: mouseClicked();
    }
}
