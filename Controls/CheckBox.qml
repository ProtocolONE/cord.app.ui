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

    implicitHeight: 16
    implicitWidth: height + 10*2 + controlText.width

    Row {
        width: parent.width
        height: parent.height
        spacing: 10

        Item {
            height: parent.height
            width: height

            Rectangle {
                id: checkBox

                anchors { fill: parent; margins: 1 }
                color: checked ? control.style.normal : "#00FFFFFF"
                border { width: 2; color: control.style.normal }

                Behavior on border.color {
                    ColorAnimation { duration: 250 }
                }

                Behavior on color {
                    ColorAnimation { duration: 250 }
                }

                Image {
                    id: checkMark

                    anchors.centerIn: parent
                    visible: control.checked
                    source: installPath + "images/Controls/CheckBox/Check.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Text {
            id: controlText

            color: control.style.normal
            font {
                family: "Arial"
                pixelSize: 16
            }

            anchors.baseline: parent.bottom
            anchors.baselineOffset: -2

            Behavior on color {
                PropertyAnimation { duration: 250 }
            }
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
        states: [
            State {
                name: ""
                PropertyChanges { target: checkBox; border.color: control.style.normal}
                PropertyChanges { target: checkBox; color: checked ? control.style.normal : "#00FFFFFF"}
                PropertyChanges { target: controlText; color: control.style.normal}
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse
                PropertyChanges { target: checkBox; border.color: control.style.hover}
                PropertyChanges { target: checkBox; color: checked ? control.style.hover : "#00FFFFFF"}
                PropertyChanges { target: controlText; color: control.style.hover; font.underline: true}
            },
            State {
                name: "Disabled"
                when: !control.enabled
                PropertyChanges { target: checkBox; border.color: control.style.disabled; opacity: 0.2}
                PropertyChanges { target: checkBox; color: checked ? control.style.disabled : "#00FFFFFF"}
                PropertyChanges { target: controlText; color: control.style.disabled; opacity: 0.2}
            }
        ]
    }

}
