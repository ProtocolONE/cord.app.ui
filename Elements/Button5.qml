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

Rectangle {
    id: button5Id
    width: buttonTextId.width + 60
    height: 28
    color: button5IdMouseArea.containsMouse ? buttonHighlightColor : buttonColor;

    border { color: "#ffffff"; width: 1 }

    property string buttonText
    property color buttonColor: "#2e6293"
    property color buttonHighlightColor: "#ff9800"
    property string fontFamily: "Tahoma"
    property int fontSize: 16
    signal buttonClicked();

    Text {
        id: buttonTextId
        text: buttonText
        anchors.verticalCenterOffset: -1
        anchors.horizontalCenter: parent.horizontalCenter

        anchors.verticalCenter: parent.verticalCenter
        font.family: fontFamily
        font.bold: false
        font.pixelSize: fontSize
        smooth: true

        color: "#ffffff"
    }

    MouseArea {
        id: button5IdMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: buttonClicked();
    }
}
