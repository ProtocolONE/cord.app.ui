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
    property InputStyleColors style: InputStyleColors {
        property color textNormal: "#3e7090"
        property color textActive: "#ffffff"
        property color backgroundActive: '#183240'
    }

    property alias icon: iconImage.source
    property alias iconBackground: controlIcon.color
    property bool iconHovered: false
    property alias iconCursor: iconMouseCursor.cursor

    property bool clearOnEsc: false

    signal iconClicked()
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

    Item {
        id: control

        anchors { fill: parent; margins: 2 }

        Rectangle {
            id: controlIcon

            property bool internaMouseOver: false
            property bool isMouseOver: internaMouseOver && mouseArea.containsMouse

            onIsMouseOverChanged: iconHovered = isMouseOver;

            function isOver(x, y) {
                var internalPos = mapToItem(controlIcon, x, y);
                if (0 < internalPos.x && internalPos.x < controlIcon.width
                        && 0 < internalPos.y && internalPos.y < controlIcon.height) {
                    internaMouseOver = true;
                    return;
                }

                internaMouseOver =  false;
            }

            visible: root.icon != ""
            width: root.icon != "" ? parent.height : 0
            height: parent.height
            color: controlBorder.color

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: iconImage

                anchors.centerIn: parent
                source: root.icon
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
                right: parent.right
                rightMargin: 10 + clearIcon.width
                verticalCenter: parent.verticalCenter
            }
            height: parent.height

            Item {
                anchors.fill: parent
                clip: true

                Text {
                    id: autoCompleteText

                    function getFirstPosition() {
                        // INFO нужен биндинг на inputBehavior.cursorPosition, но значение его не важно для расчетов.
                        if (inputBehavior.cursorPosition > 0) {
                        }

                        return inputBehavior.positionToRectangle(0).x;
                    }

                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    color: root.style.placeholder
                    font { family: "Arial"; pixelSize: root.fontSize }

                    visible: autoCompleteText.getFirstPosition() === 0
                }

                Rectangle {
                    function getWidth() {
                        if (inputBehavior.cursorPosition > 0) {
                        }

                        return inputBehavior.positionToRectangle(inputBehavior.text.length).x
                    }

                    width: getWidth();
                    height: parent.height
                    color: controlBorder.color
                }
            }

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
                    autoCompleteText.text = "";
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
        onPositionChanged: controlIcon.isOver(mouse.x, mouse.y);
    }

    Image {
        id: clearIcon

        anchors {
            right: parent.right
            rightMargin: 6
            verticalCenter: parent.verticalCenter
        }

        source: clearMouseArea.containsMouse ?
                    installPath + 'Assets/Images/Application/Widgets/Messenger/searchCloseHover.png' :
                    installPath + 'Assets/Images/Application/Widgets/Messenger/searchClose.png'

        opacity: root.text === "" ? 0 : 1

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        MouseArea {
            id: clearMouseArea

            anchors.fill: parent
            hoverEnabled: true

            onClicked: root.text = "";
        }
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: controlBorder; border.color: style.normal }
                PropertyChanges { target: controlBorder; color: style.background }
                PropertyChanges { target: inputBehavior; color: style.textNormal }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus && Qt.application.active
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: controlBorder; color: style.backgroundActive }
                PropertyChanges { target: inputBehavior; color: style.textActive }
            },
            State {
                name: "Hover"
                when: mouseArea.containsMouse
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: controlBorder; color: style.backgroundActive }
                PropertyChanges { target: inputBehavior; color: style.textActive }
            },
            State {
                name: "Disabled"
                when: !root.enabled
                PropertyChanges { target: controlBorder; border.color: style.disabled }
                PropertyChanges { target: controlBorder; color: style.background }
                PropertyChanges { target: iconImage; opacity: 0.2 }
                PropertyChanges { target: inputBehavior; opacity: 0.2 }
            }
        ]
    }
}