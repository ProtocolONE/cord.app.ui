import QtQuick 2.4
import QtMultimedia 5.4

import Tulip 1.0

import ProtocolOne.Controls 1.0
import Application.Controls 1.0
import Application.Core.Styles 1.0

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
        anchors.fill: parent
        color: Styles.dark
        opacity: 0.2
    }

    ContentThinBorder {}

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
            anchors {
                left: parent.left
                leftMargin: 8
                right: parent.right
                rightMargin: 8
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            clip: true

            Text {
                id: placeholderText

                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                color: root.style.placeholder
                opacity: 0.5
                elide: Text.ElideRight
                font { family: "Arial"; pixelSize: root.fontSize }
                visible: inputBehavior.text.length == 0
            }

            InputBehaviour {
                id: inputBehavior

                maximumLength: 30
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

            MouseArea {
                cursorShape: Qt.IBeamCursor
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
    }
}
