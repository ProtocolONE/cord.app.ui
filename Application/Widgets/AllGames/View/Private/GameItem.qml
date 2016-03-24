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
import Tulip 1.0

import GameNet.Controls 1.0
import Application.Blocks 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

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
                return qsTr("%1 ₽").arg(root.cost);
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
        id: container

        width: parent.width
        height: parent.height

        Item {
            anchors.fill: parent

            WebImage {
                id: image

                opacity: status == Image.Ready ? 1 : 0
                anchors.centerIn: parent
                asynchronous: true
                cache: false
                smooth: true

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            ContentThinBorder {}

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
                SignalBus.navigate('mygame', 'GameItem');
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
                color: Styles.popupBlockBackground
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
                color: Styles.gameGridHightlight
                width: 4
            }
            color: '#00000000'
            anchors.fill: parent
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
            text: root.buttonText()
            enabled: App.isMainServiceCanBeStarted(root.serviceItem)

            analytics {
                category: 'AllGames Item'
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
