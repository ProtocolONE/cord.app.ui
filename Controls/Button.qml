/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

Rectangle {
    id: control

    property alias enabled: buttonBehavior.enabled
    property alias text: buttonText.text
    property alias fontSize: buttonText.font.pixelSize
    property variant style: ButtonStyleColors {}
    property bool inProgress: false
    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter
    property alias containsMouse: buttonBehavior.containsMouse

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    color: control.style.normal

    Behavior on color {
        PropertyAnimation { duration: 250 }
    }

    Text {
        id: buttonText

        anchors.centerIn: parent
        color: "#FFFFFF"
        font {
            family: "Arial"
            pixelSize: 16
        }
    }

    AnimatedImage {
        id: inProgressIcon

        visible: false
        anchors.centerIn: parent
        playing: visible
        source: visible ? installPath + "images/Controls/Button/wait.gif" : ""
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: control; color: control.style.normal}
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse && !control.inProgress
                PropertyChanges { target: control; color: control.style.hover}
            },
            State {
                name: "Disabled"
                when: !control.enabled
                PropertyChanges { target: control; color: control.style.disabled; opacity: 0.2}
            },
            State {
                name: "InProgress"
                when: control.inProgress
                PropertyChanges { target: inProgressIcon; visible: true }
            }
        ]
    }

    ButtonBehavior {
        id: buttonBehavior

        anchors.fill: parent

        onEntered: control.entered();
        onExited: control.exited();
        onPressed: control.pressed(mouse);
        onClicked: control.clicked(mouse);
    }
}
