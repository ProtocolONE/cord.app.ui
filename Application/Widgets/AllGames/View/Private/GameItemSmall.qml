import QtQuick 2.4

import GameNet.Controls 1.0
import Tulip 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Column {
    id: root

    signal clicked(variant serviceItem)

    property string serviceId
    property variant serviceItem: App.serviceItemByServiceId(root.serviceId)
    property bool isTop: serviceItem ? serviceItem.typeShortcut == 'hit' : false
    property bool isNew: serviceItem ? serviceItem.typeShortcut == 'new' : false
    property bool isWebGame: serviceItem ? serviceItem.gameType != 'standalone' : false
    property bool selected: mouseArea.containsMouse || startButton.containsMouse

    property bool isStandalone: serviceItem && serviceItem.isStandalone
    property bool isClosedBeta: serviceItem && serviceItem.isClosedBeta
    property bool hasSellsItem: serviceItem && serviceItem.hasSellsItem
    property bool userHasSubscription: serviceItem && User.hasBoughtStandaloneGame(serviceItem.serviceId)
    property string cost: serviceItem && serviceItem.cost

    function buttonText() {
        if (root.isStandalone) {
            if (!root.hasSellsItem) {
                return qsTr("Скоро")
            }

            if (!root.userHasSubscription) {
                return qsTr("%1 GN").arg(root.cost);
            }

            if (root.isClosedBeta && root.hasSellsItem && root.userHasSubscription) {
                return qsTr("Оплачено");
            }
        }

        return root.serviceItem.isRunnable ? qsTr("START_GAME_BUTTON") : qsTr("ABOUT_GAME_BUTTON");
    }

    function buttonClicked() {
        App.activateGameByServiceId(root.serviceItem.serviceId);
        SignalBus.navigate('mygame', 'GameItem');

        if (root.isStandalone) {
            if (!root.hasSellsItem) {
                App.openExternalUrlWithAuth(root.serviceItem.mainUrl);
                return;
            }

            if (!root.userHasSubscription) {
                SignalBus.buyGame(root.serviceItem.serviceId);
                return;
            }

            if (root.isClosedBeta && root.hasSellsItem && root.userHasSubscription) {
                return;
            }
        }

        App.downloadButtonStart(root.serviceItem.serviceId);
    }

    spacing: 11

    Connections {
        target: SignalBus

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

            cache: false
            asynchronous: true
            anchors.centerIn: parent
            source: serviceItem.imageSmall ? serviceItem.imageSmall : ''
        }

        Stick {
            anchors {
                left: parent.left
                leftMargin: 5
            }
            type: serviceItem.typeShortcut || ''
            visible: !!serviceItem.typeShortcut && webImage.isReady
        }

        BrowserIcon {
            anchors {
                right: parent.right
                top: parent.top
                margins: 3
            }

            visible: root.isWebGame
        }

        CursorMouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                App.activateGameByServiceId(serviceItem.serviceId);
                SignalBus.navigate('mygame', 'GameItem');
                root.clicked(serviceItem);
            }
        }

        Item {
            id: informationContent

            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Styles.popupBlockBackground
                opacity: root.selected ? 0.8 : 0

                Behavior on opacity {
                    PropertyAnimation { duration: 100 }
                }
            }
        }

        Button {
            id: startButton

            width: 76
            height: 27
            anchors.centerIn: parent
            opacity: root.selected && stateGroup.state != 'Downloading' ? 1 : 0
            fontSize: 12

            text: root.buttonText()

            enabled: App.isMainServiceCanBeStarted(root.serviceItem)

            analytics {
                category: 'AllGames SmallItem'
                action: 'play'
                label: root.serviceItem.gaName
            }

            style {
                normal: Styles.primaryButtonNormal
                hover: Styles.primaryButtonHover
                disabled: Styles.primaryButtonDisabled
            }

            onClicked: root.buttonClicked();

            Behavior on opacity {
                PropertyAnimation { duration: 200 }
            }
        }

        Item {
            id: progressRect

            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                opacity: 0.74
                color: Styles.popupBlockBackground
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: (root.serviceItem.progress / 100) * parent.height

                color: Styles.gameGridProgress
                opacity: 0.5
            }
        }

        Rectangle {
            border {
                color: Styles.gameGridHightlight
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

        Text {
            id: percentTextProgress

            anchors.centerIn: parent
            text: root.serviceItem.progress + '%'
            font.pixelSize: 16
            color: Styles.lightText
        }
    }

    Text {
        width: parent.width

        text: root.serviceItem ? root.serviceItem.name : ''
        elide: Text.ElideRight
        color: root.selected ? Styles.premiumInfoText :
                               Styles.lightText
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
