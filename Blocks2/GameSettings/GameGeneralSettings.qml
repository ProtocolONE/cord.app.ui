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

import "../../Core/App.js" as App
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    property variant currentItem: App.currentGame()
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance() || {}

    function save() {

    }

    function load() {
        if (root.currentItem) {
            gameSettingsModelInstance.switchGame(root.currentItem.serviceId);
        }
    }

    Column {
        x: 30
        spacing: 20

        Item {
            width: 500
            height: 68

            Text {
                width: parent.width
                height: 16
                text: qsTr("GAME_INSTALL_PATH")
                font {
                    family: 'Arial'
                    pixelSize: 16
                }
                color: '#5c6d7d'
            }

            PathInput {
                id: installationPath

                y: 22
                width: parent.width
                height: 48
                readOnly: true
                path: gameSettingsModelInstance.installPath || ''
                onBrowseClicked: gameSettingsModelInstance.browseInstallPath();
            }
        }

        Item {
            visible: !!gameSettingsModelInstance.hasDownloadPath
            width: 500
            height: gameSettingsModelInstance.hasDownloadPath ? 68 : 0

            Text {
                width: parent.width
                height: 16
                text: qsTr("DISTRIB_INSTALL_PATH")
                font {
                    family: 'Arial'
                    pixelSize: 16
                }
                color: '#5c6d7d'
            }

            PathInput {
                id: distribPath

                y: 22
                width: parent.width
                height: 48
                readOnly: true
                path: gameSettingsModelInstance.downloadPath || ""
                onBrowseClicked: gameSettingsModelInstance.browseDownloadPath();
            }
        }

        Row {
            spacing: 9

            Button {
                width: 180
                height: 24
                style: ButtonStyleColors {
                    normal: "#3498DB"
                    hover: "#3670DC"
                }

                fontSize: 14
                text: qsTr("BUTTON_CREATE_DESKTOP_SHORTCUT")
                onClicked: {
                    gameSettingsModel.createShortcutOnDesktop();

                    GoogleAnalytics.trackEvent('/GameSettings',
                                               'Settings',
                                               'Create desktop shortcut',
                                               'Game: ' + currentItem.gaName);
                }
            }

            Button {
                width: 180
                height: 24
                style: ButtonStyleColors {
                    normal: "#3498DB"
                    hover: "#3670DC"
                }

                fontSize: 14
                text: qsTr("BUTTON_CREATE_START_MENU_SHORTCUT")
                onClicked: {
                    gameSettingsModel.createShortcutInMainMenu();

                    GoogleAnalytics.trackEvent('/GameSettings',
                                               'Settings',
                                               'Create start menu shortcut',
                                               'Game: ' + currentItem.gaName);
                }
            }
        }
    }

}
