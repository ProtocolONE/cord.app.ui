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
    id: progressBar
    color: "#00000000"

    property int progressPercent
    property int ticks

    SequentialAnimation {
        running: true
        ParallelAnimation {
            NumberAnimation { target: progressBar; property: "ticks"; from: progressPercent; to: 100; duration: 1750  }
            NumberAnimation { target: progressLighting; property: "opacity"; easing.type: Easing.InExpo; from: 1; to: 0; duration: 1750; }
        }
        PauseAnimation { duration: 20 }
        loops: Animation.Infinite
    }

    Rectangle {
        id: progressMainRect

        width: 500
        height: 6
        color: "#00000000"
        clip: true

        anchors.centerIn: parent

        Rectangle {
            height: 1
            color: "#393939"
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Rectangle {
            height: 1
            color: "#262626"
            anchors.top: parent.top
            anchors.topMargin: 4
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Rectangle {
            id: progressRect
            height: 1
            width: (parent.width / 100) * progressPercent
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.left: parent.left
            anchors.leftMargin: 0
            color: "#fdfdfd"
        }

        Image {
            id: progressLighting
            x: ticks * progressRect.width / 100 - width
            y: 1
            source: installPath + "images/lighting.png"
            visible: progressPercent > 6 ? true : false
        }

    }

}

