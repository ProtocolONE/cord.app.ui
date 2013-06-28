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
import "../../Elements" as Elements

Rectangle {
    id: root

    property alias source: image.source
    property alias headText: headText.text
    property alias descText: descText.text
    property alias buttonText: button.text

    property int countDown: 0

    signal clicked

    height: 414
    color: cursor.containsMouse || button.containsMouse ? '#287900' : '#00000000'

    Elements.CursorMouseArea {
        id: cursor

        anchors { fill: parent }
        onClicked: root.clicked()
    }

    Image {
        id: image

        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 45 }

        Text {
            anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 32 }
            text: countDown > 9 ? 9 : countDown
            color: '#ffff66'
            font { family: 'Arial'; pixelSize: 36 }
            visible: countDown < 10 && countDown > 0
        }
    }

    Text {
        id: headText

        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 135 }
        font { family: 'Arial'; pixelSize: 14 }
        color: '#ffffff'
    }

    Text {
        id: descText

        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 165 }
        width: parent.width / 1.33
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        verticalAlignment: TextEdit.AlignHCenter
        font { family: 'Arial'; pixelSize: 14 }
        color: '#ffffff'
    }

    Elements.Button {
        id: button

        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 265 }
        onClicked: root.clicked()
        hoverColor: '#ff9900'
    }
}
