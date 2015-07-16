/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

Item {
    id: control

    property ButtonStyleColors style: ButtonStyleColors {}

    property alias text: controlText.text
    property alias controlText: controlText

    property alias fontSize: controlText.font.pixelSize
    property bool checked: false
    property alias containsMouse: buttonBehavior.containsMouse
    property alias spacing: row.spacing

    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter

    signal clicked(variant mouse)
    signal toggled(bool isChecked)

    implicitHeight: 18
    implicitWidth: 18 + 10 + controlText.width

    QtObject {
        id: d

        property color contentColor: control.checked
                                     ? control.style.active
                                     : control.style.normal

        Behavior on contentColor {
            ColorAnimation { duration: 125 }
        }
    }

    Row {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Item {
            width: 18
            height: 18

            Rectangle {
                anchors.centerIn: parent
                radius: parent.width / 2
                width: parent.width - 2
                height: parent.height - 2

                color: "#00000000"
                smooth: true
                border {
                    width: 2
                    color: d.contentColor
                }
            }

            Rectangle {
                anchors.centerIn: parent
                radius: 3
                width: 6
                height: 6
                smooth: true
                color: d.contentColor
                visible: control.checked
            }
        }

        Text {
            id: controlText

            color: d.contentColor
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: "Arial"
                pixelSize: 14
            }
        }
    }

    ButtonBehavior {
        id: buttonBehavior

        enabled: control.enabled
        anchors.fill: parent
        onClicked: {
            control.clicked(mouse);
            control.toggled(control.checked);
        }
    }

    StateGroup {
        states: [
            State {
                name: ""

                PropertyChanges {
                    target: d
                    contentColor: control.checked
                                  ? control.style.active
                                  : control.style.normal
                }
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse

                PropertyChanges {
                    target: d
                    contentColor: control.checked
                                  ? control.style.activeHover
                                  : control.style.hover
                }
            },
            State {
                name: "Disabled"
                when: !control.enabled

                PropertyChanges {
                    target: d
                    contentColor: control.style.disabled
                }
            }
        ]
    }
}
