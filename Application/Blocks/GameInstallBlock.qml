/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

import "./GameInstallBlock"

Item {
    id: root

    width: 205
    height: 60

    property variant gameItem: App.currentGame()

    Item {
        id: d

        anchors {
            fill: parent
            margins: 9
        }

        function processClick() {
            if (!root.gameItem) {
                return;
            }

            App.activateGameByServiceId(root.gameItem.serviceId);

            switch (stateGroup.state) {
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

            width: parent.width
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
}

