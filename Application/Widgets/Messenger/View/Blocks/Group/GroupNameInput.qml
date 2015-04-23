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
    property alias text: inputBehavior.text
    property alias placeholder: placeholderText.text
    property alias maximumLength: inputBehavior.maximumLength

    property int fontSize: 16
    property InputStyleColors style: InputStyleColors {}

    property bool clearOnEsc: false

    signal enterPressed()
    signal tabPressed()
    signal backTabPressed()

    onFocusChanged: {
        if (focus) {
            inputBehavior.focus = true;
        }
    }

    Rectangle {
        id: controlBorder

        anchors { fill: parent; margins: 1 }
        color: style.background
        border { width: 2; color: style.normal }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }
    }

    MouseArea {
        id: mouseArea

        anchors { fill: parent; margins: 2 }
        hoverEnabled: true
        onClicked: inputBehavior.forceActiveFocus();

        Item {
            anchors {
                left: parent.left
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

                color: style.text
                fontSize: root.fontSize
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                Keys.onTabPressed: root.tabPressed();
                Keys.onBacktabPressed: root.backTabPressed();

                Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        root.enterPressed();
                        return;
                    }

                    if (event.key == Qt.Key_Escape) {
                        event.accepted = true;

                        if (root.clearOnEsc) {
                            root.text = "";
                        }

                        inputBehavior.focus = false;
                        return;
                    }

                    if (event.key >= Qt.Key_Space && event.key <= Qt.Key_AsciiTilde) {
                        if (text.length >= root.maximumLength) {
                            QMultimedia.playSound(installPath + "Assets/Sounds/GameNet/Controls/error.wav");
                            return;
                        }
                    }
                }

                onTextChanged: {
                    inputBehavior.error = false;
                }
            }

            CursorArea {
                cursor: CursorArea.IBeamCursor
                anchors.fill: parent
                height: parent.height
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
    }
}
