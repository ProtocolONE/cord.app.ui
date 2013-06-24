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
    id: mainImageButtonRectangle
    color: "#00000000"

    signal buttonPressed();

    Rectangle {
        height: 1
        color: "#ffffff"
        opacity: 0.5
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Image {
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        source: imageSource
    }

    Text {
        id: imageButtonTextId
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: qsTranslate("asdfsdf",value)
        anchors.horizontalCenterOffset: 10
        font.family: "Tahoma"
        font.bold: false
        font.pixelSize: 14
        color: "#bdbdbd"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: buttonPressed(index);
        onEntered: {
            mainImageButtonRectangle.color = "#ff9800"
            imageButtonTextId.color = "white"
        }
        onExited: {
            mainImageButtonRectangle.color = "#00000000"
            imageButtonTextId.color = "#bdbdbd"
        }
    }
}
