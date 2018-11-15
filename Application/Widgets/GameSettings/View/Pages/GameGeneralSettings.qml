import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Controls 1.0
import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0

Item {
    id: root

    property variant currentItem
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance()

    property bool notBrowser: !!root.currentItem && root.currentItem.gameType !== "browser"

    function save() {
    }

    function load() {
    }

    QtObject {
        id: d

        function editPathEnabled() {
            if (!root.currentItem)
                return false;

            return root.currentItem.serviceId !== "60000000000";
        }
    }

    Column {
        anchors {
            fill: parent
            leftMargin: 30
        }

        spacing: 20

        Item {
            width: parent.width
            height: 68
            visible: root.notBrowser

            SettingsCaption {
                text: qsTr("GAME_INSTALL_PATH")
            }

            PathInput {
                id: installationPath

                y: 22
                width: parent.width
                height: 48
                readOnly: true
                path: gameSettingsModelInstance.installPath || ''
                onBrowseClicked: gameSettingsModelInstance.browseInstallPath();
                enabled: d.editPathEnabled()
            }
        }

        Item {
            visible: !!gameSettingsModelInstance.hasDownloadPath && root.currentItem.gameType !== "browser"
            width: parent.width
            height: gameSettingsModelInstance.hasDownloadPath ? 68 : 0

            SettingsCaption {
                text: qsTr("DISTRIB_INSTALL_PATH")
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

        Item {
            visible: root.notBrowser
            width: 1
            height: 175
        }

        PopupHorizontalSplit {
            visible: root.notBrowser
        }

        Column {
            spacing: 10

            TextButton {
                text: qsTr("BUTTON_CREATE_DESKTOP_SHORTCUT")
                icon: installPath + "/Assets/Images/Application/Widgets/GameSettings/createShortcutOnDesktop.png"

                analytics {
                    category: 'GameSettings'
                    action: 'create desktop shortcut'
                    label: currentItem ? currentItem.gaName : ''
                }

                onClicked: gameSettingsModelInstance.createShortcutOnDesktop(currentItem.serviceId)
            }

            TextButton {
                icon: installPath + "/Assets/Images/Application/Widgets/GameSettings/createShortcutInMainMenu.png"
                text: qsTr("BUTTON_CREATE_START_MENU_SHORTCUT")

                analytics {
                    category: 'GameSettings'
                    action: 'create start menu shortcut'
                    label: currentItem ? currentItem.gaName : ''
                }
                onClicked: gameSettingsModelInstance.createShortcutInMainMenu(currentItem.serviceId)
            }
        }
    }
}
