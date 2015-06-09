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

import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property bool enabled: true
    property alias readOnly: inputBehavior.readOnly
    property alias text: inputBehavior.text
    property alias placeholder: placeholderText.text
    property alias maximumLength: inputBehavior.maximumLength

    property alias icon: iconImage.source
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
        anchors.fill: parent
        color: Styles.style.dark
        opacity: 0.3
        visible: mouseArea.containsMouse || clearMouseArea.containsMouse
    }

    Rectangle {
        id: controlBorder

        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }
        color: "#00000000"
        radius: 1
        border { width: 1; color: Styles.style.searchBorder }

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
            id: controlIcon

            visible: root.icon != ""
            width: root.icon != "" ? 23 : 0
            height: parent.height

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            Image {
                id: iconImage

                anchors.centerIn: parent
                source: root.icon
            }

            CursorMouseArea {
                id: iconMouseArea

                anchors.fill: parent
                onClicked: root.iconClicked();
                cursor: CursorArea.ArrowCursor
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

            Text {
                id: placeholderText

                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                color: Styles.style.textTime
                elide: Text.ElideRight
                font { family: "Arial"; pixelSize: 12 }

                visible: inputBehavior.text.length == 0
            }

            InputBehaviour {
                id: inputBehavior

                color: Styles.style.chatButtonText
                fontSize: 12
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
        }

        CursorArea {
            cursor: CursorArea.IBeamCursor
            anchors {
                left: controlIcon.right
                right: parent.right
            }
            height: parent.height
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
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

        CursorMouseArea {
            id: clearMouseArea

            anchors.fill: parent
            hoverEnabled: true

            onClicked: root.text = "";
        }
    }
}
