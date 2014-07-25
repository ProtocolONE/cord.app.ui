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

    implicitHeight: 16
    implicitWidth: childrenRect.width

    Row {
        id: row

        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Item {
            width: 20
            height: 20

            Image {
                id: checkBox

                source: checked ?
                            installPath + "Assets/Images/GameNet/Controls/RadioButton/normal_checked.png" :
                            installPath + "Assets/Images/GameNet/Controls/RadioButton/normal_unchecked.png"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
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

            color: control.style.normal
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: "Arial"
                pixelSize: 16
            }

            Behavior on color {
                PropertyAnimation { duration: 250 }
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
                    target: checkBox
                    source: checked ?
                                installPath + "Assets/Images/GameNet/Controls/RadioButton/normal_checked.png" :
                                installPath + "Assets/Images/GameNet/Controls/RadioButton/normal_unchecked.png"
                }
                PropertyChanges { target: controlText; color: control.style.normal}
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse
                PropertyChanges {
                    target: checkBox
                    source: checked ?
                                installPath + "Assets/Images/GameNet/Controls/RadioButton/hover_checked.png" :
                                installPath + "Assets/Images/GameNet/Controls/RadioButton/hover_unchecked.png"
                }
                PropertyChanges { target: controlText; color: control.style.hover; font.underline: true}
            },
            State {
                name: "Disabled"
                when: !control.enabled
                PropertyChanges {
                    target: checkBox
                    source: checked ?
                                installPath + "Assets/Images/GameNet/Controls/RadioButton/normal_checked.png" :
                                installPath + "Assets/Images/GameNet/Controls/RadioButton/normal_unchecked.png"
                    opacity: 0.2
                }
                PropertyChanges { target: controlText; color: control.style.disabled; opacity: 0.2}
            }
        ]
    }
}
