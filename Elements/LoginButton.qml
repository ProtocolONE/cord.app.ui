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
    width: 80
    height: 25

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

    width: 80
    height: 25
        anchors {left: parent.left; leftMargin: 1; top: parent.top; topMargin: 1;}
        color: enterAction.containsMouse ? "#006600" : "#339900"

        Image {
            width: 16
            height: 18
            anchors { top: parent.top; topMargin: 4;  }
            anchors { left: parent.left; leftMargin: 6; }
            fillMode: Image.PreserveAspectFit
            source: installPath + "images/key.png"
        }

        Text {
            color: "#fff"
            text: buttonText;
            anchors { verticalCenter: parent.verticalCenter }
            anchors { left: parent.left; leftMargin: 30; }
            wrapMode: Text.NoWrap
            style: Text.Normal
            smooth: true
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
