import QtQuick 2.4
import QtMultimedia 5.4

import GameNet.Controls 1.0
import Application.Core.Styles 1.0

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
        color: Styles.dark
        opacity: 0.3
        visible: mouseArea.containsMouse || clearMouseArea.containsMouse
    }

    Rectangle {
        id: controlBorder

        anchors.fill: parent
        color: "#00000000"
        radius: 1
        border { width: 1; color: Styles.searchBorder }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }
    }

    SoundEffect {
        id: errorSound

        source: installPath + "Assets/Sounds/Controls/error.wav"
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
                cursor: Qt.ArrowCursor
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

                color: Styles.textBase
                elide: Text.ElideRight
                font { family: "Arial"; pixelSize: 12 }

                visible: inputBehavior.text.length == 0
            }

            InputBehaviour {
                id: inputBehavior

                color: Styles.textBase
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
                            if (!errorSound.playing) {
                                errorSound.play();
                            }
                            return;
                        }
                    }
                }

                onTextChanged: {
                    inputBehavior.error = false;
                }
            }
        }

        MouseArea {
            cursorShape: Qt.IBeamCursor
            anchors {
                left: controlIcon.right
                right: parent.right
            }
            height: parent.height
            acceptedButtons: Qt.NoButton
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

        source: clearMouseArea.containsMouse
                ? installPath + Styles.messengerSearchCloseIcon.replace('.png', 'Hover.png')
                : installPath + Styles.messengerSearchCloseIcon

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
