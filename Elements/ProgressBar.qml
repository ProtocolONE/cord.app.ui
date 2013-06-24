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

Item {
    id: progressBar

    property bool running: true
    property int progress: 0

    onRunningChanged: {
        if (running) {
            hideAnim.complete();
            startAnimTimer.start();
        } else {
            startAnimTimer.stop();
            progressAnim.stop();
        }
    }

    Timer {
        id: startAnimTimer

        running: false
        interval: 500
        repeat: false
        onTriggered: progressAnim.start()
    }

    SequentialAnimation {
        id: hideAnim

        running: !progressBar.running

        PropertyAnimation {
            target: lightImage;
            property: "opacity";
            to: 0;
            duration: 250
        }

        PropertyAction { target: lightImage; property: "anchors.leftMargin"; value: -250; }
    }

    Item {
        id: progressMainRect

        width: parent.width
        height: 6
        clip: true

        anchors.centerIn: parent

        Rectangle {
            height: 1
            color: "#ffffff"
            opacity: 0.3
            anchors { left: parent.left; top: parent.top; right: parent.right; }
            anchors { topMargin: 3; }
        }

        Rectangle {
            height: 1
            color: "#ffffff"
            opacity: 0.5
            width: Math.floor(parent.width * progress / 100)
            anchors { left: parent.left; top: parent.top; topMargin: 3; }
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
            id: progressAnim

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

