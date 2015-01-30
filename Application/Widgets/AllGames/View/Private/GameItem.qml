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

import GameNet.Controls 1.0
import Application.Blocks 1.0

import "../../../../../Application/Core/App.js" as App
import "../../../../Core/Styles.js" as Styles

Item {
    id: root

    signal clicked(variant serviceItem)

    property alias source: image.source
    property string serviceId
    property variant serviceItemGrid
    property variant serviceItem: App.serviceItemByServiceId(root.serviceId)
    property bool isTop: serviceItem ? serviceItem.typeShortcut == 'hit' : false
    property bool isNew: serviceItem ? serviceItem.typeShortcut == 'new' : false
    property bool isWebGame: serviceItem ? serviceItem.gameType != 'standalone' : false

    property int pauseAnimation

    property bool selected: mouseArea.containsMouse || startButton.containsMouse

    Connections {
        target: App.signalBus()

        onProgressChanged: {
            if (serviceItem.serviceId != gameItem.serviceId) {
                return
            }

            stateGroup.state = (gameItem.status === 'Downloading' || gameItem.status === 'Starting') ?
                        'Downloading' : 'Normal'
        }
    }

    Item {
        id: container

        width: parent.width
        height: parent.height

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Styles.style.messengerGridBackgroud
            }

            WebImage {
                id: image

                opacity: status == Image.Ready ? 1 : 0
                anchors.centerIn: parent
                asynchronous: true
                smooth: true

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            Rectangle {
                anchors.fill: parent
                color: '#00000000'
                border.color: '#ffffff'
                opacity: 0.075
            }

            Stick {
                anchors {
                    left: parent.left
                    leftMargin: 17
                }
                type: serviceItem.typeShortcut || ''
                visible: !!serviceItem.typeShortcut && image.isReady
            }

            BrowserIcon {
                anchors {
                    right: parent.right
                    top: parent.top
                    margins: 4
                }

                visible: root.isWebGame
            }
        }

        CursorMouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                App.activateGameByServiceId(serviceItem.serviceId);
                App.navigate('mygame', 'GameItem');
                root.clicked(serviceItem);
            }
        }

        Item {
            id: informationContent

            function isSmall() {
                if (root.serviceItemGrid.width == 1 &&
                    root.serviceItemGrid.height == 1) {
                    return true;
                }

                return false;
            }

            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Styles.style.messengerGridBackgroud
                opacity: root.selected || stateGroup.state == 'Downloading' ? 0.77 : 0
                z: informationContent.isSmall() && stateGroup.state != 'Downloading' ? 1 : 0

                Behavior on opacity {
                    PropertyAnimation { duration: 100 }
                }
            }

            Column {
                anchors { left: parent.left; bottom: parent.bottom; right: parent.right; margins: 16; bottomMargin: 10 }

                spacing: 12

                GameItemTitle {
                    width: parent.width

                    serviceItem: root.serviceItem
                }

                DownloadProgress {
                    id: hightlightItem

                    width: parent.width

                    serviceItem: root.serviceItem
                }
            }
        }

        Rectangle {
            border {
                color: Styles.style.messengerGridHightlight
                width: 4
            }
            color: '#00000000'
            anchors { fill: parent }
            opacity: root.selected ? 1 : 0

            Behavior on opacity {
                PropertyAnimation { duration: 150 }
            }
        }

        Button {
            id: startButton

            width: 116
            height: 32
            anchors.centerIn: parent
            opacity: root.selected ? 1 : 0
            text: root.serviceItem.isRunnable ? qsTr("START_GAME_BUTTON") : qsTr("ABOUT_GAME_BUTTON")
            enabled: App.isMainServiceCanBeStarted(root.serviceItem)

            analytics {
                page: '/AllGames'
                category: 'Game ' + root.serviceItem.gaName
                action: 'Play'
                label: 'GameItem'
            }

            style {
                normal: Styles.style.gameInstallButtonNormal
                hover: Styles.style.gameInstallButtonHover
                disabled: Styles.style.gameInstallButtonDisabled
            }

            onClicked: {
                App.activateGameByServiceId(root.serviceItem.serviceId);
                App.navigate('mygame', 'GameItem');
                App.downloadButtonStart(serviceItem.serviceId);
            }

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
                PropertyChanges { target: startButton; visible: true }
                PropertyChanges { target: hightlightItem; visible: false }
            },
            State {
                name: "Downloading"
                PropertyChanges { target: startButton; visible: false }
                PropertyChanges { target: hightlightItem; visible: true }
            }
        ]
    }
}
