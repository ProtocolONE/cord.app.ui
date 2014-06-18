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

import GameNet.Controls 1.0
import Application.Blocks 1.0

import "../../../Application/Core/App.js" as App

Rectangle {
    width: 245
    height: 180

    property alias source: image.source
    property variant serviceItem
    property int pauseAnimation

    property variant formFactorSizes: {
        1: {
            width: 240,
            height: 180
        },
        2: {
            width: 495,
            height: 180
        }
    }

    property bool selected: mouseArea.containsMouse || startButton.containsMouse

    function show() {
        showAnimation.restart()
    }

    function hide() {
        root.visible = false;
        container.visible = false;
        container.opacity = 0;
        informationContent.opacity = 0;
        mouseArea.visible = false;
    }

    width: formFactorSizes[serviceItem.formFactor].width
    height: formFactorSizes[serviceItem.formFactor].height

    Connections {
        target: App.signalBus()

        onProgressChanged: {
            if (serviceItem.serviceId != gameItem.serviceId) {
                return
            }

            stateGroup.state = (gameItem.status === 'Downloading') ? 'Downloading' : 'Normal'
        }
    }

    Item {
        id: container

        visible: false
        opacity: 0
        anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }

        SequentialAnimation {
            id: showAnimation

            PauseAnimation { duration: root.pauseAnimation }
            PropertyAnimation { target: root; property: "visible"; to: true}
            PropertyAnimation { target: container; property: "visible"; to: true}

            ParallelAnimation {
                NumberAnimation {
                    target: container
                    easing.type: Easing.OutBack
                    property: "width"
                    from: root.width * 0.50
                    to: root.width
                    duration: 500
                }

                NumberAnimation {
                    target: container
                    easing.type: Easing.OutBack
                    property: "height"
                    from: root.height * 0.50
                    to: root.height
                    duration: 500
                }

                NumberAnimation {
                    target: container
                    easing.type: Easing.InOutQuad
                    property: "opacity"
                    from: 0.1
                    to: 1
                    duration: 500
                }

                SequentialAnimation {
                    PauseAnimation { duration: 350 }
                    PropertyAnimation {
                        target: informationContent
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 250
                    }
                }
            }

            PropertyAnimation { target: mouseArea; property: "visible"; to: true}
        }

        Rectangle {
            //Image Border
            color: '#ff6555'
            anchors { fill: parent; margins: -5 }
            opacity: root.selected ? 1 : 0

            Behavior on opacity {
                PropertyAnimation { duration: 250 }
            }
        }

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: '#092135'
            }

            Image {
                id: image

                anchors.fill: parent
                opacity: status == Image.Ready ? 1 : 0
                asynchronous: true
                smooth: true

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }
        }

        CursorMouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
            visible: false

            onClicked: App.activateGame(serviceItem.serviceId)
        }

        Item {
            id: informationContent

            opacity: 0
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: '#092135'
                opacity: root.selected ? 0.8 : 0

                Behavior on opacity {
                    PropertyAnimation { duration: 200 }
                }
            }

            Item {
                id: hightlightItem

                width: 240
                height: 50
                anchors { left: parent.left; bottom: parent.bottom}

                Rectangle {
                    anchors.fill: parent
                    color: '#092135'
                    opacity: !root.selected ? 0.8 : 0

                    Behavior on opacity {
                        PropertyAnimation { duration: 200 }
                    }
                }

                Column {
                    anchors { fill: parent; margins: 8 }
                    spacing: 10

                    GameItemTitle {
                        serviceItem: root.serviceItem
                    }

                    DownloadStatus {
                        id: downloadStatus

                        anchors { left: parent.left; right: parent.right}
                        serviceItem: root.serviceItem
                    }
                }
            }
        }

        Button {
            id: startButton

            width: 160
            height: 36
            anchors.centerIn: parent
            opacity: root.selected ? 1 : 0
            text: qsTr("START_GAME_BUTTON")
            onClicked: App.downloadButtonStart(serviceItem.serviceId)

            Behavior on opacity {
                PropertyAnimation { duration: 200 }
            }
        }
    }

    StateGroup {
        id: stateGroup

        state: "Normal"
        states: [
            State {
                name: "Normal"
                PropertyChanges { target: downloadStatus; visible: false }
                PropertyChanges { target: startButton; visible: true }
                PropertyChanges { target: hightlightItem; height: 50 }
            },
            State {
                name: "Downloading"
                PropertyChanges { target: downloadStatus; visible: true }
                PropertyChanges { target: startButton; visible: false }
                PropertyChanges { target: hightlightItem; height: 90 }
            }
        ]
    }
}
