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

    property alias analytics: buttonBehavior.analytics
    property bool checkable: false
    property bool checked: false
    property alias enabled: buttonBehavior.enabled
    property alias text: textItem.text
    property alias fontSize: textItem.font.pixelSize
    property alias font: textItem.font

    property alias layoutDirection: controlRow.layoutDirection
    property alias icon: iconImage.source

    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter
    property ButtonStyleColors style: ButtonStyleColors {}

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    implicitHeight: Math.max(textItem.height, iconImage.hasIcon ? iconImage.height : 0)
    implicitWidth: mathTextItem.width + (iconImage.hasIcon ? 30 : 0)

    Row {
        id: controlRow

        anchors.fill: parent
        spacing: 7

        Item {
            width: visible ? 20 : 0
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            visible: iconImage.hasIcon

            Image {
                id: iconImage

                property bool hasIcon: iconImage.source != ""

                anchors.centerIn: parent
            }
        }

        Text {
            id: textItem

            color: control.style.normal
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: "Arial"
                pixelSize: 16
            }

            text: " "
            width: control.width - (iconImage.hasIcon ? 30 : 0)
            wrapMode: Text.WordWrap

            Behavior on color {
                PropertyAnimation { duration: 250 }
            }
        }
    }

    // INFO по умолчанию считаем кнопку однострочной и считаем ее размер из размера текст.
    // Но если задать фиксированную ширину кнопки, то она станет мультистрочной, ишрина текста
    // будет расчитывать из размера контрола. Этот текст позволяет реализовать эту логику.
    Text {
        id: mathTextItem

        text: textItem.text
        font: textItem.font
        visible: false
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
                PropertyChanges { target: textItem; color: control.style.normal }
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse
                PropertyChanges { target: textItem; color: control.style.hover; font.underline: true }
            },
            State {
                name: "Disabled"
                when: !control.enabled
                PropertyChanges { target: textItem; color: control.style.disabled }
            },
            State {
                name: "Selected"
                when: control.checked
                PropertyChanges { target: textItem; color: control.style.active; }
            }

        ]
    }
}
