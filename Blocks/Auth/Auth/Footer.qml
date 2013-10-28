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
import "../../../Elements" as Elements

Column {
    id: root

    signal clicked();

    spacing: 11

    Rectangle {
        y: 5

        width: parent.width
        height: 1
        color: '#4c9926'
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter

        font { family: 'Arial'; pixelSize: 14; underline: true }
        color: "#ffffff"
        text: qsTr("REGISTER_NEW_USER_LINK")

        Elements.CursorMouseArea {
            anchors { fill: parent }
            onClicked: root.clicked()
        }
    }
}
