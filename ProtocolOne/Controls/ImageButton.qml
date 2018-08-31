import QtQuick 2.4

Item {
    id: control

    property alias imageAnchors: buttonIcon.anchors
    property alias analytics: buttonBehavior.analytics
    property alias toolTip: buttonBehavior.toolTip
    property alias tooltipPosition: buttonBehavior.tooltipPosition
    property alias tooltipGlueCenter: buttonBehavior.tooltipGlueCenter
    property ButtonStyleColors style: ButtonStyleColors {}
    property ButtonStyleImages styleImages: ButtonStyleImages {}
    property alias containsMouse: buttonBehavior.containsMouse
    property alias radius: buttonBackground.radius

    signal entered()
    signal exited()
    signal pressed(variant mouse)
    signal clicked(variant mouse)

    Rectangle {
        id: buttonBackground

        color: control.style.normal
        anchors.fill: parent

        Behavior on color {
            PropertyAnimation { duration: 250 }
        }
    }

    Image {
        id: buttonIcon

        source: control.styleImages.normal
        cache: true
        asynchronous: false
        anchors.centerIn: parent
    }

    StateGroup {
        states: [
            State {
                name: ""
                PropertyChanges { target: buttonBackground; color: control.style.normal}
                PropertyChanges { target: buttonIcon; source: control.styleImages.normal}
            },
            State {
                name: "Hover"
                when: buttonBehavior.containsMouse && !control.inProgress
                PropertyChanges { target: buttonBackground; color: control.style.hover}
                PropertyChanges {
                    target: buttonIcon;
                    source: control.styleImages.hover != "" ? control.styleImages.hover : control.styleImages.normal
                }
            },
            State {
                name: "Disabled"
                when: !control.enabled
                PropertyChanges { target: buttonBackground; color: control.style.disabled; opacity: 0.2}
                PropertyChanges { target: buttonIcon; source: control.styleImages.disabled; opacity: 0.2}
            },
            State {
                name: "InProgress"
                when: control.inProgress
                PropertyChanges { target: inProgressIcon; visible: true }
            }
        ]
    }

    ButtonBehavior {
        id: buttonBehavior

        anchors.fill: parent

        analytics {
            category: 'image button'
            action: 'click'
        }
        onEntered: control.entered();
        onExited: control.exited();
        onPressed: control.pressed(mouse);
        onClicked: control.clicked(mouse);
    }
}
