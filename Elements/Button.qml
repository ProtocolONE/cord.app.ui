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

Rectangle {
    id: buttonT1

    property color buttonColor: "#00000000"
    property color buttonColorHover: "#006600"
    property string buttonText
    property string fontFamily: fontTahoma.name

    signal buttonPressed();

    color: buttonColor
    border.color: "#fff"
    height: 27
    width: 70

    Image {
        id: buttonT1Img
        anchors { fill: parent; leftMargin: 1; topMargin: 1 }
        sourceSize.height: 27
        source: installPath + "images/button_bg.png"
    }

    Text {
        id: text1
        x: 24
        y: 7
        text: buttonText
        color: "#ffffff"
        font { family: fontFamily; weight: "Light"; pixelSize: 16; bold: false }
        anchors.centerIn: parent
    }

    Elements.CursorMouseArea {
        id: buttonMouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: buttonPressed();
        onEntered: {
            buttonT1Img.source = ""
            buttonT1.color = buttonColorHover
        }

        onExited: {
            buttonT1Img.source = installPath + "images/button_bg.png"
            buttonT1.color = buttonColor
        }
    }
}
