import QtQuick 2.4
import ProtocolOne.Controls 1.0

Item {
    id: control

    property alias analytics: buttonBehavior.analytics
    property alias enabled: buttonBehavior.enabled

    property alias icon: image.source
    property alias text: buttonText.text
    property alias textColor: buttonText.color
    property alias fontSize: buttonText.font.pixelSize

    property CheckedButtonStyle style: CheckedButtonStyle {}
    property bool inProgress: false
    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter
    property alias containsMouse: buttonBehavior.containsMouse
    property bool buttonPressed: buttonBehavior.buttonPressed

    property bool checked: true
    property bool boldBorder: false

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    implicitWidth: (control.text && control.icon)
                   ? (buttonText.width + image.width + 36 + 6)
                   : (control.text ? buttonText.width + 36 : image.width + 12)

    implicitHeight: 31

    function getControlState() {
        if (!control.enabled) {
            return 'Disabled';
        }

        if (control.inProgress) {
            return 'InProgress';
        }

        if (control.checked) {
            return control.containsMouse ? 'CheckedHover' : 'CheckedNormal';
        }

        return control.containsMouse ? 'Hover' : 'Normal';
    }

    Rectangle {
        id: background

        anchors.fill: parent
        opacity: 1
        color: control.style.active

        Behavior on opacity {
            PropertyAnimation { duration: 250 }
        }
    }

    Row {
        id: content

        visible: true
        opacity: 1
        anchors.centerIn: parent
        spacing: 6

        Image {
            id: image

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: buttonText

            anchors.verticalCenter: parent.verticalCenter
            font {
                family: "Arial"
                pixelSize: 12
            }

            Behavior on color {
                PropertyAnimation { duration: 250 }
            }
        }
    }

    Rectangle {
        id: borderRect

        property bool boldBorder: control.boldBorder & control.checked & control.enabled

        anchors.fill: parent
        color: "#00000000"
        border {
            width: borderRect.boldBorder ? 2 : 1
            color: control.style.inactive
        }

        radius: !control.text ? 1 : 0

        Behavior on border.color {
            PropertyAnimation { duration: 250 }
        }
    }

    AnimatedImage {
        id: inProgressIcon

        visible: false
        anchors.centerIn: parent
        playing: visible
        source: visible ? installPath + "Assets/Images/ProtocolOne/Controls/Button/wait.gif" : ""
    }

    StateGroup {
        state: control.getControlState()

        states: [
            State {
                name: "Hover"
                PropertyChanges { target: background; opacity: 1 }
                PropertyChanges { target: borderRect; border.color: control.style.active}
                PropertyChanges { target: content; opacity: 1 }
                PropertyChanges { target: buttonText; color: control.style.textActive }
            },
            State {
                name: "Normal"
                PropertyChanges { target: background; opacity: 0 }
                PropertyChanges { target: borderRect; border.color: control.style.inactive}
                PropertyChanges { target: content; opacity: 0.5 }
                PropertyChanges { target: buttonText; color: control.style.textInactive }
            },
            State {
                name: "CheckedHover"
                PropertyChanges { target: background; opacity: 1 }
                PropertyChanges { target: borderRect; border.color: control.style.active}
                PropertyChanges { target: content; opacity: 1 }
                PropertyChanges { target: buttonText; color: control.style.textActive }
            },
            State {
                name: "CheckedNormal"
                PropertyChanges { target: background; opacity: 0.28 }
                PropertyChanges { target: borderRect; border.color: control.style.active}
                PropertyChanges { target: content; opacity: 1 }
                PropertyChanges { target: buttonText; color: control.style.textActive }
            },
            State {
                name: "Disabled"

                PropertyChanges { target: background; opacity: 0 }
                PropertyChanges { target: borderRect; border.color: control.style.inactive}
                PropertyChanges { target: content; opacity: 0.5 }
                PropertyChanges { target: buttonText; color: control.style.textActive }
            },
            State {
                name: "InProgress"
                PropertyChanges { target: inProgressIcon; visible: true }
                PropertyChanges { target: background; opacity: 0.28 }
                PropertyChanges { target: borderRect; border.color: control.style.active}
                PropertyChanges { target: content; visible: false }
            }
        ]
    }

    ButtonBehavior {
        id: buttonBehavior

        anchors.fill: parent
        visible: control.enabled && !control.inProgress

        onEntered: control.entered();
        onExited: control.exited();
        onPressed: control.pressed(mouse);
        onClicked: control.clicked(mouse);
    }
}
