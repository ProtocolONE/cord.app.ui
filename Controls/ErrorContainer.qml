/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

Item {
    id: root

    default property alias data: stash.data

    property bool error: false
    property alias errorMessage: errorContainer.text
    property alias style: errorContainer.style

    height: stash.height + (errorContainer.visible ? (errorContainer.height) : 0)

    Column {
        width: parent.width
        height: parent.height

        Item {
            id: stash

            width: parent.width
            height: childrenRect.height > 0 ? childrenRect.height : 0
            z: 1
        }

        ErrorMessage {
            id: errorContainer

            width: parent.width
            opacity: 0
            visible: root.error && root.errorMessage.length > 0
            style {
                text: "#FC3147"
                background: "#00000000"
            }
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 150
        }
    }

    StateGroup {
        state: ""
        states: [
            State {
                name: ""
                PropertyChanges { target: errorContainer; opacity: 0 }
            },
            State {
                name: "Error"
                when: root.error
                PropertyChanges { target: errorContainer; opacity: 1 }
            }
        ]

        transitions: [
            Transition {
                from: ""
                to: "Error"

                SequentialAnimation {
                    PauseAnimation { duration: 150 }

                    PropertyAnimation {
                        properties: "opacity"
                        duration: 150
                    }
                }
            }
        ]
    }
}

