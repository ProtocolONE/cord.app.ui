import QtQuick 1.1

import GameNet.Controls 1.0

import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles

Column {
    id: root

    property string serviceId
    property variant serviceItem: App.serviceItemByServiceId(root.serviceId)
    property bool isTop: serviceItem ? serviceItem.typeShortcut == 'hit' : false
    property bool isNew: serviceItem ? serviceItem.typeShortcut == 'new' : false
    property bool isWebGame: serviceItem ? serviceItem.gameType != 'standalone' : false
    property bool selected: mouseArea.containsMouse || startButton.containsMouse

    spacing: 15

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
        width: 87
        height: 87

        WebImage {
            id: webImage

            width: parent.width
            height: parent.height

            anchors.centerIn: parent
            source: serviceItem.imageSmall ? App.host() + serviceItem.imageSmall : ''
        }

        Stick {
            anchors {
                left: parent.left
                leftMargin: 5
            }
            type: 0
            visible: root.isTop && webImage.isReady
            text: qsTr("GAME_TOP_STICK")
        }

        Stick {
            anchors {
                left: parent.left
                leftMargin: 5
            }
            type: 1
            visible: root.isNew && webImage.isReady
            text: qsTr("GAME_NEW_STICK")
        }

        CursorMouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                App.activateGameByServiceId(serviceItem.serviceId);
                App.navigate('mygame', 'GameItem');
            }
        }

        Item {
            id: informationContent

            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: '#092135'
                opacity: root.selected ? 0.8 : 0

                Behavior on opacity {
                    PropertyAnimation { duration: 100 }
                }
            }
        }

        Rectangle {
            border {
                color: '#dec37b'
                width: 4
            }
            color: '#00000000'
            anchors { fill: parent }
            radius: 4
            opacity: root.selected ? 1 : 0

            Behavior on opacity {
                PropertyAnimation { duration: 150 }
            }
        }

        Button {
            id: startButton

            width: 76
            height: 27
            anchors.centerIn: parent
            opacity: root.selected && stateGroup.state != 'Downloading' ? 1 : 0
            fontSize: 12
            text: qsTr("START_GAME_BUTTON")
            enabled: App.isMainServiceCanBeStarted(root.serviceItem)

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

        Rectangle {
            id: progressRect

            anchors.bottom: parent.bottom
            width: parent.width
            height: (root.serviceItem.progress / 100) * parent.height

            color: '#247f71'
            opacity: 0.75
        }

        Text {
            id: percentTextProgress

            anchors.centerIn: parent
            text: root.serviceItem.progress + '%'
            font.pixelSize: 16
            color: '#ffffff'
        }
    }

    Text {
        width: parent.width

        text: root.serviceItem ? root.serviceItem.name : ''
        elide: Text.ElideRight
        color: root.selected ? '#dec37b' : '#ffffff'
        font.pixelSize: 12
    }

    StateGroup {
        id: stateGroup

        state: "Normal"
        states: [
            State {
                name: "Normal"
                PropertyChanges { target: progressRect; visible: false }
                PropertyChanges { target: percentTextProgress; visible: false }
            },
            State {
                name: "Downloading"
                PropertyChanges { target: progressRect; visible: true }
                PropertyChanges { target: percentTextProgress; visible: true }
            }
        ]
    }
}
