import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    property bool enabled: true
    property alias readOnly: inputBehavior.readOnly
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

        anchors.fill: parent
        color: "#FFFFFF"
        border { width: 2; color: style.normal }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }
    }

    MouseArea {
        id: control

        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        anchors { fill: parent; margins: 2 }

        onContainsMouseChanged: {
            if (!containsMouse) {
                inputBehavior.focus = false;
            }
        }

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

        Item {
            id: browseButton

            property bool isMouseOver: btnCursorArea.containsMouse

            width: parent.height
            height: parent.height
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            visible: root.enabled

            Image {
                id: browsebuttonImage

                anchors.centerIn: parent
                source: browseButton.isMouseOver
                        ? installPath + "Assets/Images/ProtocolOne/Controls/PathInput/browse_a.png"
                        : installPath + "Assets/Images/ProtocolOne/Controls/PathInput/browse_n.png"
            }

            CursorMouseArea {
                id: btnCursorArea

                cursor: Qt.PointingHandCursor
                anchors.fill: parent
                onClicked: root.browseClicked();
            }
        }
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
                when: control.containsMouse
                PropertyChanges { target: controlBorder; border.color: style.active }
                PropertyChanges { target: inputBehavior; color: style.active }
            },
            State {
                name: "Disabled"
                when: !root.enabled
                PropertyChanges { target: controlBorder; border.color: style.disabled }
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
