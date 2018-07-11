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
import Application.Core.MessageBox 1.0

PopupBase {
    id: root

    property variant currentGame
    property alias createDesktopShortcut: desktopShortcut.checked
    property alias createStartMenuShortcut: startMenuShortcut.checked
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance()

    Component.onCompleted: {
        root.currentGame = App.currentGame();
        root.gameSettingsModelInstance.switchGame(root.currentGame.serviceId);
    }

    title: qsTr("INSTALL_VIEW_TITLE").arg(currentGame.name)
    height: 375
    clip: true

    QtObject {
        id: d

        property bool isBattleCarnival: !!root.currentGame && root.currentGame.serviceId == "370000000000"

        function battleCarnivalHack() {
            // INFO https://jira.gamenet.ru/browse/QGNA-1611
            var newPath = gameSettingsModelInstance.installPath;
            var validContactPattern = new RegExp("^[-0-9a-zA-Z:_()\\\\\/\. ]+$");
            if (!validContactPattern.test(newPath)) {
                console.log('Bad path', newPath);
                installationPath.bestPath = d.getExepectedPath();
                gameSettingsModelInstance.installPath = installationPath.bestPath;

                MessageBox.show(qsTr("INFO_CAPTION"), qsTr("BATTLE_CARNIVAL_HACK"),
                                MessageBox.button.Ok,
                                function(result) { });

                return;
            }

            installationPath.bestPath = gameSettingsModelInstance.installPath;
        }

        function defaultBattleCarnival() {
            var expected = App.getExpectedInstallPath(currentGame.serviceId);
            var validContactPattern = new RegExp("^[-0-9a-zA-Z:_()\\\\\/\.]+$");
            if (!validContactPattern.test(expected)) {
                return App.getBestInstallPath(currentGame.serviceId);
            }

            return expected;
        }

        function getExepectedPath() {
            if (d.isBattleCarnival) {
                return d.defaultBattleCarnival();
            }

            return App.getExpectedInstallPath(currentGame.serviceId);
        }
    }

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

            property string bestPath: d.getExepectedPath()

            y: 22
            width: parent.width
            height: 48
            path: installationPath.bestPath
            readOnly: true
            onBrowseClicked: {
                gameSettingsModelConnection.target = gameSettingsModelInstance;
                gameSettingsModelInstance.browseInstallPath(installationPath.bestPath);
            }

            Connections {
                id: gameSettingsModelConnection

                ignoreUnknownSignals: true
                onInstallPathChanged: {
                    gameSettingsModelConnection.target = null;

                    if (d.isBattleCarnival) {
                        d.battleCarnivalHack();
                        return;
                    }

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
