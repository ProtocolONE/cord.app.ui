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

    Rectangle {
        id: progressMainRect

        width: parent.width
        height: 6
        color: "#00000000"
        clip: true

        anchors.centerIn: parent

        Rectangle {
            height: 1
            color: "#ffffff"
            opacity: 0.3
            anchors { left: parent.left; top: parent.top; right: parent.right; }
            anchors { topMargin: 3; rightMargin: 0; leftMargin: 0; }
        }

        Image {
            id: lightImage

            y: 1
            anchors.left: parent.left
            anchors.leftMargin: -250
            source: installPath + "images/progression.png"
            width: 250
        }

        SequentialAnimation {
            running: lightImage.visible
            loops: Animation.Infinite

            PauseAnimation { duration: 20 }
            ParallelAnimation {
                PropertyAnimation { target: lightImage; property: "opacity"; from: 0; to: 1 ; duration: 100 }
            }
            PropertyAnimation { target: lightImage; property: "anchors.leftMargin"; from: -250; to: progressBar.width ; duration: 3000; }
            PropertyAnimation { target: lightImage;  property: "opacity"; from: 1; to: 0 ; duration: 200 }
        }
    }
}

