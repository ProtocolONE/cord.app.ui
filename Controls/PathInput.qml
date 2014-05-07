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

Item {
    id: root

    property bool enabled: true
    property alias path: inputBehavior.text
    property int fontSize: 16
    property variant style: InputStyleColors {}

    signal browseClicked()

    onFocusChanged: {
        if (focus) {
            inputBehavior.focus = true;
        }
    }

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

        Item {
            anchors {
                left: parent.left
                leftMargin: 10
                right: browseButton.left
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            height: parent.height

            InputBehaviour {
                id: inputBehavior

                color: style.normal
                fontSize: root.fontSize
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                Behavior on color {
                    ColorAnimation { duration: 300 }
                }
            }
        }

        Rectangle {
            id: browseButton

            property bool internaMouseOver: false
            property bool isMouseOver: internaMouseOver && mouseArea.containsMouse

            onIsMouseOverChanged: root.iconHovered = isMouseOver;

            function isOver(x, y) {
                var internalPos = mapToItem(browseButton, x, y);
                if (0 < internalPos.x && internalPos.x < browseButton.width
                    && 0 < internalPos.y && internalPos.y < browseButton.height) {
                    internaMouseOver = true;
                    return;
                }

                internaMouseOver =  false;
            }

            width: parent.height
            height: parent.height
            color: "#FFFFFF"

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: browsebuttonImage

                anchors.centerIn: parent
                source: installPath + "images/Controls/PathInput/browse_n.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.browseClicked();
            }

            CursorArea {
                id: iconMouseCursor

                cursor: CursorArea.ArrowCursor
                anchors.fill: parent
                visible: mouseArea.containsMouse
            }
        }
    }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onClicked: inputBehavior.focus = true;
        onPositionChanged: browseButton.isOver(mouse.x, mouse.y);
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: controlBorder; border.color: style.normal }
                PropertyChanges {target: browsebuttonImage; source: installPath + "images/Controls/PathInput/browse_n.png"}
                PropertyChanges { target: inputBehavior; color: style.normal }
            },
            State {
                name: "Active"
                when: inputBehavior.activeFocus
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
                PropertyChanges {target: browsebuttonImage; source: installPath + "images/Controls/PathInput/browse_a.png"}
            },
            State {
                name: "Hover"
                when: mouseArea.containsMouse
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
                PropertyChanges {target: browsebuttonImage; source: installPath + "images/Controls/PathInput/browse_a.png"}

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
                PropertyChanges {target: browsebuttonImage; source: installPath + "images/Controls/PathInput/browse_n.png"}
                PropertyChanges { target: inputBehavior; color: style.error }
            },
            State {
                name: "ErrorActive"
                when: inputBehavior.activeFocus && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges {target: browsebuttonImage; source: installPath + "images/Controls/PathInput/browse_a.png"}
                PropertyChanges { target: inputBehavior; color: style.hover }
            },
            State {
                name: "ErrorHover"
                when: mouseArea.containsMouse && inputBehavior.error
                PropertyChanges { target: controlBorder; border.color: style.hover }
                PropertyChanges {target: browsebuttonImage; source: installPath + "images/Controls/PathInput/browse_a.png"}
                PropertyChanges { target: inputBehavior; color: style.error }
            }
        ]
    }
}
