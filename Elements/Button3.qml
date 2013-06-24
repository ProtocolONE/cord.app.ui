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

Rectangle {
    id: button3Id

    property string buttonText
    property color buttonHighlightColor: "#ff9800"
    property string fontFamily: "Tahoma"
    property int fontSize: 16

    signal buttonClicked();

    width: buttonText2.width + 30
    height: 28
    opacity:  mouser.containsMouse ? 1 : 0.8
    color: mouser.containsMouse ? buttonHighlightColor : "#00000000"

    border { color: "#FFFFFF"; width: 1 }

    Text {
        id: buttonText2

        text: buttonText
        anchors { centerIn: parent; verticalCenterOffset: -1 }
        font { family: fontFamily; pixelSize: fontSize; bold: false }
        smooth: true
        opacity: mouser.containsMouse ? 1 : 0.8
        color: "#FFFFFF"
    }

    Elements.CursorMouseArea {
        id: mouser

        anchors.fill: parent
        hoverEnabled: true
        onClicked: buttonClicked();
    }
}
