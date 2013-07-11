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

    property bool running: false
    property int progress: 0

    onRunningChanged: progressAnim.switchTimer();
    Component.onCompleted: progressAnim.switchTimer();

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
        PropertyAction { target: progressAnim; property: "ainmationStep"; value: 0; }
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

        Timer {
            id: progressAnim

            property real ainmationStep: 0

            function switchTimer()
            {
                if (progressBar.running) {
                    hideAnim.complete();
                    lightImage.opacity = 1;
                    progressAnim.ainmationStep = 0;
                    progressAnim.start();
                } else {
                    progressAnim.stop();
                }
            }

            interval: 33
            repeat: true
            onTriggered: {
                var dif = 33 * ((progressBar.width + 250) / 3000)
                ainmationStep = (ainmationStep + dif) % (progressBar.width + 250)
                lightImage.anchors.leftMargin = Math.floor(ainmationStep - 250);
            }

            running: false
        }
    }
}

