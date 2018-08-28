import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0
import Application.Controls 1.0
import Application.Core.MessageBox 1.0

import "./GameInstallBlock"

Item {
    id: root

    width: 205
    height: 60

    property variant gameItem: App.currentGame()

    property bool isStandalone: gameItem && gameItem.isStandalone
    property bool isClosedBeta: gameItem && gameItem.isClosedBeta
    property bool hasSellsItem: gameItem && gameItem.hasSellsItem
    property bool userHasSubscription: gameItem && User.hasBoughtStandaloneGame(gameItem.serviceId)
    property string cost: (gameItem && gameItem.cost) || ""

    Item {
        id: d

        anchors {
            fill: parent
            margins: 9
        }

        function outerMenuClicked(root, x, y) {

            var posInItem = menuButton.mapFromItem(root, x, y);
            var contains =  posInItem.x >= 0
                    && posInItem.y >=0
                    && posInItem.x <= menuButton.width
                    && posInItem.y <= menuButton.height;

            return contains;
        }

        function contextMenuClicked(action) {
            ContextMenu.hide();

            switch(action) {

            case "download":
                root.gameItem.noRun = true;
                App.downloadButtonStart(root.gameItem.serviceId);
                break;
            case "refresh":
                root.gameItem.noRun = true;
                root.gameItem.showInfo = true;
                App.downloadButtonStart(root.gameItem.serviceId);
                break;
            case "restore":
                App.gameSettingsModelInstance().switchGame(root.gameItem.serviceId);
                App.gameSettingsModelInstance().restoreClient();
                break;
            }
        }

        function fillContextMenu(menu) {
            var options = [];

            if (stateGroup.state === "NotInstalled") {

                options.push({
                                 name: qsTr("PLAY_MENU_DOWNLOAD"),
                                 action: "download"
                             });

            } else {
                options.push({
                                 name: qsTr("PLAY_MENU_REFRESH"),
                                 action: "refresh"
                             });

                options.push({
                                 name: qsTr("PLAY_MENU_RESTORE"),
                                 action: "restore"
                             });
            }

            menu.fill(options);
        }

        function processClick() {
            if (!root.gameItem) {
                return;
            }

            App.activateGameByServiceId(root.gameItem.serviceId);

            switch (stateGroup.state) {
            case 'StandAlone_hasNotSellItem':
                App.openExternalUrlWithAuth(root.gameItem.mainUrl)
                break;

            case 'StandAlone_hasSellItem_userNotBought':
                SignalBus.buyGame(root.gameItem.serviceId);
                break;

            case 'StandAlone_closebeta_hasSellItem_userBought':
                break;

            case 'Error':
                Popup.show('GameDownloadError');
                break;
            case 'Downloading':
                Popup.show('GameLoad');
                break;
            case 'Uninstalling':
                Popup.show('GameUninstall');
                break;
            default:
                App.downloadButtonStart(root.gameItem.serviceId);
                Ga.trackEvent('GameInstallBlock', 'play', root.gameItem.gaName);
            }
        }

        Button {
            id: button

            width: parent.width - (menuButton.visible ? menuButton.width + menuButtonSeparator.width : 0)
            height: parent.height
            visible: true
            enabled: App.isMainServiceCanBeStarted(root.gameItem)
            style {
                normal: stateGroup.state == 'Error' ? Styles.errorButtonNormal : Styles.primaryButtonNormal
                hover: stateGroup.state == 'Error' ? Styles.errorButtonHover : Styles.primaryButtonHover
                disabled: Styles.primaryButtonDisabled
            }
            onClicked: d.processClick()
            ShakeLogic {
                target: parent
                enabled: ['Downloading', 'Starting', 'Error', 'Uninstalling'].indexOf(stateGroup.state) === -1
            }
        }

        Rectangle {
            id: menuButtonSeparator
            width: 2
            height: parent.height
            color: button.enabled ? Styles.buttonSeparatorNormal : Styles.buttonSeparatorDisabled
            anchors.right: menuButton.left
            visible: menuButton.visible
        }

        ImageButton {
            id: menuButton

            width: 40
            height: button.height
            visible: button.visible && button.enabled && root.gameItem.gameType !== "browser" && ['Starting', 'Started'].indexOf(stateGroup.state) === -1
            anchors.right: parent.right
            style {
                normal: button.style.normal
                hover: button.style.hover
                disabled: button.style.disabled
            }
            onClicked: {

                if (ContextMenu.isShown()) {
                    ContextMenu.hide();
                    return;
                }

                if (stateGroup.state === "NotInstalled")
                    ContextMenu.show({x:0, y:-44}, button, playContextMenuComponent, {});
                else if (d.isBlackDesert)
                    ContextMenu.show({x:0, y:-100}, button, playContextMenuComponent, {});
                else
                    ContextMenu.show({x:0, y:-72}, button, playContextMenuComponent, {});
            }
            styleImages {
                normal: stateGroup.imagePath + 'up_arrow.png'
            }
        }

        MiniButton {
            id: miniButton

            width: parent.width
            height: 21
            visible: false
            containsMouse: mouser.containsMouse
            enabled: App.isMainServiceCanBeStarted(root.gameItem)
        }

        DownloadStatus {
            id: downloadStatus

            anchors.bottom: parent.bottom
            visible: false
            height: 21
            width: parent.width
            textOpacity: 0.5
            textColor: Styles.textBase
            spacing: 5
            serviceItem: root.gameItem
        }

        CursorMouseArea {
            id: mouser

            anchors.fill: parent
            visible: !button.visible
            onClicked: d.processClick();
            enabled: App.isMainServiceCanBeStarted(root.gameItem)
        }
    }

    StateGroup {
        id: stateGroup

        property string imagePath: installPath + '/Assets/Images/Application/Blocks/GameInstallBlock/'

        //INFO Помните, порядок следования стейтов важен - при совпадении критериев выигрывает тот, кто выше. Тут
        //выписаны все стейты, даже те, которые прямо сейчас не используются, но, возможно, будут использоваться
        //в будущем.
        states: [
            State {
                name: 'OnlyBigButton'
                PropertyChanges {target: button; visible: true}
                PropertyChanges {target: miniButton; visible: false}
                PropertyChanges {target: downloadStatus; visible: false}
            },
            State {
                name: 'WithMiniButton'
                PropertyChanges {target: button; visible: false}
                PropertyChanges {target: miniButton; visible: true}
                PropertyChanges {target: downloadStatus; visible: true}
            },

            State {
                name: 'StandAlone_hasNotSellItem'
                extend: 'OnlyBigButton'
                when: root.gameItem && root.isStandalone && !root.hasSellsItem
                PropertyChanges { target: button; text: qsTr("Скоро") }
            },

            State {
                name: 'StandAlone_hasSellItem_userNotBought'
                extend: 'OnlyBigButton'
                when: root.gameItem && root.isStandalone && root.hasSellsItem && !root.userHasSubscription
                PropertyChanges { target: button; text: qsTr("%1 GN").arg(root.cost) }
            },

            State {
                name: 'StandAlone_closebeta_hasSellItem_userBought'
                extend: 'OnlyBigButton'
                when: root.gameItem && root.isStandalone && root.isClosedBeta && root.hasSellsItem && root.userHasSubscription
                PropertyChanges {target: button; text: qsTr("Оплачено")}
            },

            State {
                name: 'NonRunnableGame'
                extend: 'OnlyBigButton'
                when: root.gameItem && !root.gameItem.isRunnable
                PropertyChanges {target: button; text: qsTr("ABOUT_PLAY_NOT_INSTALLED")}
            },
            State {
                name: 'Normal'
                extend: 'OnlyBigButton'
                when: root.gameItem && (root.gameItem.status === "Normal" && root.gameItem.isInstalled)
                PropertyChanges {target: button; text: qsTr("BUTTON_PLAY_NOT_INSTALLED")}
            },
            State {
                name: 'NotInstalled'
                extend: 'Normal'
                when: root.gameItem && (root.gameItem.status === "Normal" && !root.gameItem.isInstalled)
            },
            State {
                name: 'Starting'
                extend: 'Normal'
                when: root.gameItem && root.gameItem.status === "Starting"
            },
            State {
                name: 'Started'
                extend: 'Normal'
                when: root.gameItem && root.gameItem.status === "Started"
            },
            State {
                name: 'Finished'
                extend: 'Normal'
                when: root.gameItem && root.gameItem.status === "Finished"
            },
            State {
                name: 'Error'
                extend: 'OnlyBigButton'
                when: root.gameItem && root.gameItem.status === "Error"
                PropertyChanges {target: button; text: qsTr("BUTTON_PLAY_ERROR_STATE")}
            },
            State {
                name: 'Pause'
                extend: 'WithMiniButton'
                when: root.gameItem && root.gameItem.status === "Paused"
                PropertyChanges {target: miniButton; text: qsTr("BUTTON_PLAY_ON_PAUSED_STATE")}
                PropertyChanges {target: miniButton; source: stateGroup.imagePath + 'play.png'}
            },
            State {
                name: 'Uninstalling'
                extend: 'WithMiniButton'
                when: root.gameItem && root.gameItem.status === "Uninstalling"
                PropertyChanges {target: button; text: qsTr("BUTTON_UNINSTALLING_STATE")}
                PropertyChanges {target: miniButton; text: qsTr("BUTTON_UNINSTALLING_STATE")}
                PropertyChanges {target: miniButton; source: stateGroup.imagePath + 'delete.png'}
            },
            State {
                name: 'Downloading'
                extend: 'WithMiniButton'
                when: root.gameItem && root.gameItem.status === "Downloading"
                PropertyChanges {target: miniButton; text: qsTr("BUTTON_PLAY_ON_DETAILS_STATE")}
                PropertyChanges {target: miniButton; source: stateGroup.imagePath + 'pause.png'}
            },
            State {
                name: 'AllreadyDownloaded'
                extend: 'OnlyBigButton'
                when: root.gameItem && root.gameItem.allreadyDownloaded
                PropertyChanges {target: button; text: qsTr("BUTTON_PLAY_DOWNLOADED_AND_READY_STATE")}
            }
        ]
    }

    Component {
        id: playContextMenuComponent

        ContextMenuView {
            id: contextMenu
            width: button.width + menuButtonSeparator.width + menuButton.width

            onContextClicked: d.contextMenuClicked(action)
            onOuterClicked:{
                canHide = !d.outerMenuClicked(root, x, y);
            }
            Component.onCompleted: d.fillContextMenu(contextMenu);
        }
    }
}

