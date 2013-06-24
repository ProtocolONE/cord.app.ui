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
    id: textClick
    width: 181
    height: 32
    state: "Normal"

    property string buttonText
    signal textClicked();

    Text {
        id: mainClickText
        text: buttonText
        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        font.family: "Tahoma"
        font.bold: false
        font.pixelSize: 18
        font.weight: "Light"
        opacity: 1
        smooth: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            textClicked();

            if (textClick.state == "Normal")
                textClick.state = "Active";
        }
    }
    states: [
        State {
            name: "Normal"
            PropertyChanges { target: textClick; color: "#00000000" }
            PropertyChanges { target: mainClickText; color: "white" }
        },
        State {
            name: "Active"
            PropertyChanges { target: textClick; color: "#ff9800" }
            PropertyChanges { target: mainClickText; color: "black" }
        }
    ]

}
