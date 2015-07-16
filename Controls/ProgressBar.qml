/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    property ProgressBarStyleColors style: ProgressBarStyleColors {}
    property int progress: 0
    property bool animated: false
    property int duration: 2000
    property alias cursor: cursorArea.cursor
    property alias toolTip: cursorArea.toolTip
    property alias tooltipPosition: cursorArea.tooltipPosition
    property alias tooltipGlueCenter: cursorArea.tooltipGlueCenter

    signal clicked()

    clip: true

    Rectangle {
        id: line

        width: Math.floor((progress / 100) * root.width);
        height: root.height
        color: root.style.line

        Behavior on width {
            PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 }
        }
    }

    Rectangle {
        height: root.height
        anchors { left: line.right; right: root.right; }
        color: root.style.background
    }

    Image {
        id: lightImage

        anchors { left: parent.left; leftMargin: -lightImage.width; }
        source: installPath + "Assets/Images/GameNet/Controls/ProgressBar/gradient.png"
        height: root.height
    }

    Timer {
        id: animationTimer

        property real animationStep: Math.floor((root.width + lightImage.width)/(root.duration/33));

        interval: 33
        repeat: true
        running: false
        onTriggered: {
            var currentPos = lightImage.anchors.leftMargin >= root.width ? -lightImage.width : lightImage.anchors.leftMargin;
            lightImage.anchors.leftMargin = Math.floor(currentPos + animationStep);
        }
    }

    CursorMouseArea {
        id: cursorArea

        cursor: Qt.ArrowCursor
        anchors.fill: parent
        onClicked: root.clicked();
    }

    StateGroup {
        states: [
            State {
                name: 'Animated'
                when: root.animated
                PropertyChanges { target: lightImage; opacity: 1; }
                PropertyChanges { target: animationTimer; running: true; }
            },
            State {
                name: 'NotAnimated'
                when: !root.animated
            }
        ]

        transitions: [
            Transition {
                to: "NotAnimated"
                SequentialAnimation {
                    PropertyAnimation { target: lightImage; property: "opacity"; to: 0; duration: 250; }
                    PropertyAction { target: lightImage; property: "anchors.leftMargin"; value: -lightImage.width; }
                    PropertyAction { target: animationTimer; property: "running"; value: false; }
                }
            }
        ]
    }
}

