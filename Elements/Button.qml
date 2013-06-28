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

Rectangle {
    id: root

    default property alias content: container.data

    property alias buttonColor: root.color // @deprecated
    property alias buttonColorHover: root.hoverColor // @deprecated
    property alias fontFamily: label.font.family // @deprecated
    property alias buttonText: label.text // @deprecated

    property alias font: label.font
    property alias text: label.text
    property alias containsMouse: mouseArea.containsMouse
    property color hoverColor: '#006600'

    signal buttonPressed(); //@deprecated

    signal clicked();

    color:  mouseArea.containsMouse ? root.hoverColor : "#00000000"
    border { width: 1; color: "#ffffff" }
    height: 28
    width: Math.max(70, container.width + label.width + 20)

    Row {
        id: container

        x: 3
        width: childrenRect.width
        height: parent.height
    }

    Text {
        id: label

        anchors { verticalCenter: parent.verticalCenter }
        anchors { left: container.right; leftMargin: (root.width - container.width - width - container.x) / 2 }
        font { family: 'Arial'; pixelSize: 16 }
        color: "#ffffff"
        smooth: true
        text: buttonText
    }

    CursorMouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked();
            buttonPressed();
        }
    }
}
