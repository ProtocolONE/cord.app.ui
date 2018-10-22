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

Text {
    id: control

    property alias analytics: buttonBehavior.analytics
    property bool checkable: false
    property bool checked: false
    property alias fontSize: control.font.pixelSize
    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter
    property ButtonStyleColors style: ButtonStyleColors {}

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    color: control.style.normal
    smooth: true
    font {
        family: "Arial"
        pixelSize: 16
    }

    Behavior on color {
        PropertyAnimation { duration: 250 }
    }

    ButtonBehavior {
        id: buttonBehavior

        anchors.fill: parent

        onEntered: control.entered();
        onExited: control.exited();
        onPressed: control.pressed(mouse);
        onClicked: control.clicked(mouse);
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: control; color: control.style.normal}
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse
                PropertyChanges { target: control; color: control.style.hover; font.underline: true}
            },
            State {
                name: "Disabled"
                when: !control.enabled
                PropertyChanges { target: control; color: control.style.disabled; opacity: 0.2}
            },
            State {
                name: "Selected"
                when: control.checked
                PropertyChanges { target: control; color: control.style.active; }
            }

        ]
    }
}
