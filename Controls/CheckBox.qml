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

Item {
    id: control

    property ButtonStyleColors style: ButtonStyleColors {}

    property alias enabled: buttonBehavior.enabled
    property alias text: controlText.text
    property alias fontSize: controlText.font.pixelSize
    property bool checked: false

    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter

    signal clicked(variant mouse)
    signal toggled(bool checked)

    implicitHeight: 20
    implicitWidth: 20 + 10*2 + controlText.width
    opacity: 1

    Behavior on opacity {
        NumberAnimation { duration: 125 }
    }

    QtObject {
        id: d

        property color base: control.style.normal

        Behavior on base {
            ColorAnimation { duration: 125 }
        }
    }

    Row {
        anchors.fill: parent
        spacing: 10

        Item {
            height: 20
            width: 20
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: checkboxBorder

                anchors { fill: parent; margins: 1 }
                color: "#00FFFFFF"
                opacity: 1
                visible: opacity > 0
                border { width: 2; color: d.base }

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            Rectangle {
                id: checkboxChecked

                anchors.fill: parent
                color: d.base
                opacity: 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            Image {
                id: checkMark

                anchors.centerIn: parent
                visible: control.checked
                source: installPath + "Assets/Images/GameNet/Controls/CheckBox/Check.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text {
            id: controlText

            color: d.base
            font { family: "Arial"; pixelSize: 14 }
            anchors { baseline: parent.bottom; baselineOffset: -5 }
        }
    }

    ButtonBehavior {
        id: buttonBehavior

        anchors.fill: parent

        onClicked: {
            control.clicked(mouse);
            control.checked = !control.checked;
            control.toggled(control.checked);
        }
    }

    StateGroup {
        state: "Normal"

        states: [
            State {
                name: "Disabled"
                when: !control.enabled
                extend: "Normal"
                PropertyChanges { target: d; base: control.style.disabled }
                PropertyChanges { target: control; opacity: 0.5 }
            }
            ,
            State {
                name: "CheckedHover"
                when: control.checked && buttonBehavior.containsMouse
                extend: "Checked"
                PropertyChanges { target: d; base: control.style.activeHover }

            }
            ,
            State {
                name: "Checked"
                when: control.checked && !buttonBehavior.containsMouse
                PropertyChanges { target: checkboxChecked; opacity: 1 }
                PropertyChanges { target: checkboxBorder; opacity: 0 }
                PropertyChanges { target: d; base: control.style.active }
            }

            ,
            State {
                name: "Hover"
                when: !control.checked && buttonBehavior.containsMouse
                extend: "Normal"
                PropertyChanges { target: d; base: control.style.hover }
            }
            ,
            State {
                name: "Normal"
                when: !control.checked && !buttonBehavior.containsMouse
                PropertyChanges { target: checkboxChecked; opacity: 0 }
                PropertyChanges { target: checkboxBorder; opacity: 1 }
                PropertyChanges { target: d; base: control.style.normal }
            }
        ]
    }
}
