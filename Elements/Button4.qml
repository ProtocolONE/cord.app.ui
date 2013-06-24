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
    id: button4Id

    property int borderWidth: 1
    property string buttonText
    property string fontFamily: "Tahoma"
    property color buttonHighlightColor: "#ff9800"
    property color buttonColor: "#535761"
    property int fontSize: 16
    property bool isEnabled: false

    signal buttonClicked();

    width: buttonText4.width + 30
    height: 28
    border { color: "#FFFFFF"; width: button4Id.borderWidth }
    color: button4Mouser.containsMouse ? buttonHighlightColor : buttonColor
    opacity: isEnabled ? 1 : 0.4

    Text {
        id: buttonText4

        text: buttonText
        anchors { centerIn: parent; verticalCenterOffset: -1 }
        font { family: fontFamily; pixelSize: fontSize; bold: false }
        smooth: true
        color: "#FFFFFF"
    }

    Elements.CursorMouseArea {
        id: button4Mouser

        anchors.fill: parent
        visible: isEnabled
        hoverEnabled: true
        onClicked: buttonClicked();
    }
}
