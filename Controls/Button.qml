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

    property alias analytics: buttonBehavior.analytics
    property alias enabled: buttonBehavior.enabled
    property alias text: buttonText.text
    property alias textColor: buttonText.color
    property alias fontSize: buttonText.font.pixelSize
    property alias font: buttonText.font
    property ButtonStyleColors style: ButtonStyleColors {}
    property bool inProgress: false
    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter
    property alias containsMouse: buttonBehavior.containsMouse
    property bool buttonPressed: buttonBehavior.buttonPressed

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    color: control.style.normal

    implicitWidth: 25 + buttonText.width + 25
    implicitHeight: 48

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
        text: " "
    }

    AnimatedImage {
        id: inProgressIcon

        visible: false
        anchors.centerIn: parent
        playing: visible
        source: visible ? installPath + "Assets/Images/GameNet/Controls/Button/wait.gif" : ""
    }

    StateGroup {
        state: function() {
            if (!control.enabled) {
                return 'Disabled';
            }

            if (control.inProgress) {
                return 'InProgress';
            }

            return control.containsMouse ? 'Hover' : 'Normal';
        }()

        states: [
            State {
                name: "Hover"
                PropertyChanges { target: control; color: control.style.hover}
                PropertyChanges { target: buttonText; visible: true }
            },
            State {
                name: "Normal"
                PropertyChanges { target: control; color: control.style.normal}
                PropertyChanges { target: buttonText; visible: true }
            },
            State {
                name: "Disabled"
                PropertyChanges { target: control; color: control.style.disabled}
                PropertyChanges { target: buttonText; visible: true }
            },
            State {
                name: "InProgress"
                PropertyChanges { target: inProgressIcon; visible: true }
                PropertyChanges { target: buttonText; visible: false }
            }
        ]
    }

    ButtonBehavior {
        id: buttonBehavior

        anchors.fill: parent
        visible: control.enabled && !control.inProgress

        analytics {
            category: 'button'
            action: 'click'
        }

        onEntered: control.entered();
        onExited: control.exited();
        onPressed: control.pressed(mouse);
        onClicked: control.clicked(mouse);
    }
}
