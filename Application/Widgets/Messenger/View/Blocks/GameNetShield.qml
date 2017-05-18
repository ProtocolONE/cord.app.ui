/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2017, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import GameNet.Controls 1.0

Rectangle {
    implicitWidth: shieldItemText.width + 10
    implicitHeight: 16
    color: "#FF4F02"

    Text {
        id: shieldItemText

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 5
        }

        color: "#F3DCA5"
        font {
            pixelSize: 12
            family: "Segoe UI"
            letterSpacing: -0.72
        }

        text: "GameNet"
    }

    CursorMouseArea {
        anchors.fill: parent
        toolTip: qsTr("Сотрудник GameNet")
        cursorShape: Qt.ArrowCursor
    }
}
