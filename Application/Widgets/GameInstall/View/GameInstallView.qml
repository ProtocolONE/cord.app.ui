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

import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Blocks.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0

PopupBase {
    id: root

    property variant currentGame
    property alias createDesktopShortcut: desktopShortcut.checked
    property alias createStartMenuShortcut: startMenuShortcut.checked
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance()

    Component.onCompleted: {
        root.currentGame = App.currentGame();
    }

    title: qsTr("INSTALL_VIEW_TITLE").arg(currentGame.name)
    height: 375
    clip: true

    Item {
        width: parent.width
        height: 68

        Text {
            width: parent.width
            height: 16
            font {
                family: 'Arial'
                pixelSize: 16
            }
            color: defaultTextColor
            smooth: true
            text: qsTr("DESTINATION_FOLDER_CAPTION")
        }

        PathInput {
            id: installationPath

            property string bestPath: App.getExpectedInstallPath(currentGame.serviceId)

            y: 22
            width: parent.width
            height: 48
            path: installationPath.bestPath
            readOnly: true
            onBrowseClicked: {
                gameSettingsModelInstance.browseInstallPath(installationPath.bestPath);
            }

            Connections {
                target: gameSettingsModelInstance
                ignoreUnknownSignals: true
                onInstallPathChanged: {
                    installationPath.bestPath = gameSettingsModelInstance.installPath;
                }
            }
        }
    }

    CheckBox {
        id: desktopShortcut

        width: 300
        fontSize: 15
        checked: true
        text: qsTr("CREATE_DESKTOP_SHORTCUT")
    }

    CheckBox {
        id: startMenuShortcut

        width: 300
        fontSize: 15
        checked: true
        text: qsTr("CREATE_STARTMENU_SHORTCUT")
    }

    Item {
        width: root.width
        height: 20

        Text {
            width: parent.width
            anchors {
                bottom: parent.bottom
            }
            text: qsTr("LICENSE_TIP")
            font {
                family: 'Arial'
                pixelSize: 12
            }
            color: defaultTextColor
            onLinkActivated: App.openExternalUrl(currentGame.licenseUrl)

            MouseArea {
                anchors.fill: parent
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                acceptedButtons: Qt.NoButton
            }
        }
    }

    PopupHorizontalSplit {}

    PrimaryButton {
        id: installButton

        ShakeAnimation {
            id: shakeAnimation

            target: installButton
            property: "anchors.leftMargin"
            from: 0
            shakeValue: 2
            shakeTime: 120
        }

        Timer {
            id: shakeAnimationTimer

            interval: 5000
            running: root.visible
            onTriggered: shakeAnimation.start();
        }

        width: 200
        height: 48
        analytics {
            category: 'GameInstall'
            action: 'play'
            label: root.currentGame.gaName
        }
        anchors {
            left: parent.left
            leftMargin: 0
        }
        text: qsTr("INSTALL_BUTTON_CAPTION")
        onClicked: {
            if (root.currentGame.gameType != 'browser') {
                App.setServiceInstallPath(root.currentGame.serviceId,
                                          installationPath.path);
            }

            App.acceptFirstLicense(currentGame.serviceId);

            gameSettingsModelInstance.switchGame(currentGame.serviceId);

            if (desktopShortcut.checked) {
                gameSettingsModelInstance.createShortcutOnDesktop(currentGame.serviceId);
            }

            if (startMenuShortcut.checked) {
                gameSettingsModelInstance.createShortcutInMainMenu(currentGame.serviceId);
            }

            App.downloadButtonStart(currentGame.serviceId);

            root.close();
        }
    }
}
