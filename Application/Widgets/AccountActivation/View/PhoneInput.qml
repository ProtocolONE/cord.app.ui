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
import Tulip 1.0
import GameNet.Controls 1.0

Item {
    id: root

    property bool enabled: true
    property alias readOnly: inputBehavior.readOnly
    property alias error: inputBehavior.error
    property alias text: inputBehavior.text
    property alias placeholder: placeholderText.text
    property alias inputMask: inputBehavior.inputMask

    property int fontSize: 16
    property variant style: InputStyleColors {}

    signal enterPressed()
    signal tabPressed()
    signal backTabPressed()

    onFocusChanged: {
        if (focus) {
            inputBehavior.focus = true
        }
    }

    implicitHeight: 48

    Rectangle {
        id: controlBorder

        anchors { fill: parent; margins: 1 }
        color: "#FFFFFF"
        border { width: 2; color: style.normal }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }
    }

    Item {
        id: control

        anchors { fill: parent; margins: 2 }

        Rectangle {
            id: controlIcon

            visible: root.icon != ""
            width: iconImage.width
            height: parent.height
            color: "#FFFFFF"

            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: iconImage

                anchors.centerIn: parent
                source: installPath + "Assets/Images/Application/Widgets/AccountActivation/phone_plus.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.iconClicked();
            }

            CursorArea {
                id: iconMouseCursor

                cursor: CursorArea.ArrowCursor
                anchors.fill: parent
                visible: mouseArea.containsMouse
            }
        }

        Item {
            anchors {
                left: controlIcon.right
                leftMargin: 10
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            height: parent.height

            Text {
                id: placeholderText

                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                color: root.style.placeholder
                elide: Text.ElideRight
                font { family: "Arial"; pixelSize: root.fontSize }

                visible: inputBehavior.text.length == 0
            }

            InputBehaviour {
                id: inputBehavior

                fontSize: root.fontSize
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                width: body.width
                validator: RegExpValidator { regExp: /^[\(\)\[\]]*([0-9][ \-(\)\[\]]*){6,19}$/ }

                onTextChanged: {
                    inputBehavior.error = false;
                }

                Keys.onTabPressed: {
                    root.tabPressed();
                }

                Keys.onBacktabPressed: {
                    root.backTabPressed();
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        root.enterPressed();
                        return;
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onClicked: inputBehavior.focus = true;
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: controlBorder; border.color: style.normal }
                PropertyChanges { target: inputBehavior; color: style.normal }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
            },
            State {
                name: "Hover"
                when: mouseArea.containsMouse
                PropertyChanges { target: controlBorder; border.color: style.active }

            },
            State {
                name: "Disabled"
                when: !root.enabled
                PropertyChanges { target: controlBorder; border.color: style.disabled }
                PropertyChanges { target: iconImage; opacity: 0.2 }
                PropertyChanges { target: inputBehavior; opacity: 0.2 }
            },
            State {
                name: "ErrorNormal"
                when: inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.error }
                PropertyChanges { target: inputBehavior; color: style.error }
            },
            State {
                name: "ErrorActive"
                when: inputBehavior.activeFocus && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges { target: inputBehavior; color: style.hover }
            },
            State {
                name: "ErrorHover"
                when: mouseArea.containsMouse && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges { target: inputBehavior; color: style.error }
            }
        ]
    }
}
