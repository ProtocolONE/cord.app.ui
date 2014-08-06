/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0

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

        CursorArea {
            id: mouseCursor

            anchors.fill: parent
            cursor: CursorArea.ArrowCursor
        }
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
                            mouseCursor.cursor = CursorArea.PointingHandCursor;
                            mouseCursor.cursor = CursorArea.ArrowCursor;
                            root.forceActiveFocus();
                        }
                    }

                    PauseAnimation { duration: root.interval }
                    NumberAnimation { target: back; property: "opacity"; duration: 3000; to: root.maxOpacity; easing.type: Easing.InOutQuad }
                }
            }
        ]
    }
}

