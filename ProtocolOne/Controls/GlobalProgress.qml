import QtQuick 2.4

Item {
    id: root

    property int interval: 5000
    property alias showWaitImage: animatedImage.visible
    property real maxOpacity: 0.75

    visible: false

    implicitWidth: 1000
    implicitHeight: 600

    Rectangle {
        id: back

        anchors.fill: parent
        color: "#000000"
        opacity: 0
        visible: false

        AnimatedImage {
            id: animatedImage

            anchors.centerIn: parent
            playing: back.visible
            source: installPath + "Assets/Images/wait_animation.gif"
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor
    }

    StateGroup {
        state: "off"
        states: [
            State {
                name: "off"

                PropertyChanges {
                    target: back
                    visible: true
                    opacity: 0
                }
            },
            State {
                name: "on"
                when: root.visible

                PropertyChanges {
                    target: back
                    visible: true
                    opacity: 0
                }
            }
        ]

        transitions: [
            Transition {
                from: "off"
                to: "on"

                SequentialAnimation {
                    ScriptAction {
                        script: {
                            // INFO этот трюк ресетит курсор
                            // UPDATE 22.07.2015 этот трюк больше не работает, и нет решения.
                            // mouse.cursorShape = Qt.PointingHandCursor;
                            // mouse.cursorShape = Qt.ArrowCursor;
                            root.forceActiveFocus();
                        }
                    }

                    PauseAnimation { duration: root.interval }
                    NumberAnimation {
                        target: back;
                        property: "opacity";
                        duration: 3000;
                        to: root.maxOpacity;
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]
    }
}

