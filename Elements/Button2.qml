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
    id: button2Id

    width: buttonText2.width + 30
    height: 28
    border { color: "#FFFFFF"; width: 1 }
    color: mouseAreaId.containsMouse ? "#ff9800" : "#00000000"

    property string buttonText: "OK"
    property int fontSize: 16
    property string fontFamily: "Tahoma"

    property int buttonId: -1
    property int messageId

    signal buttonClicked(int messageId, int buttonId);
    signal clicked(int buttonId)

    Text {
        id: buttonText2
        text: buttonText
        anchors { centerIn: parent; verticalCenterOffset: 1 }
        font { family: fontFamily; pixelSize: fontSize; bold: false }
        smooth: true
        opacity: 1
        color: "#FFFFFF"
    }

    Elements.CursorMouseArea {
        id: mouseAreaId

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            buttonClicked(messageId, buttonId);
            button2Id.clicked(buttonId);
        }
    }
}
