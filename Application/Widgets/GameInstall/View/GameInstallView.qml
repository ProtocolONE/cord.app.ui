/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property variant currentGame: App.currentGame()
    property alias createDesktopShortcut: desktopShortcut.checked
    property alias createStartMenuShortcut: startMenuShortcut.checked
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance() || {}

    width: 630
    height: 375
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "#F0F5F8"
    }

    Column {
        y: 20
        spacing: 20

        Text {
            anchors {
                left: parent.left
                leftMargin: 20
            }
            font {
                family: 'Arial'
                pixelSize: 20
            }
            color: '#343537'
            smooth: true
            text: qsTr("INSTALL_VIEW_TITLE").arg(currentGame.name)
        }

        HorizontalSplit {
            width: root.width

            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Item {
            width: 500
            height: 68
            anchors {
                left: parent.left
                leftMargin: 20
            }

            Text {
                width: parent.width
                height: 16
                font {
                    family: 'Arial'
                    pixelSize: 16
                }
                color: '#5c6d7d'
                smooth: true
                text: qsTr("DESTINATION_FOLDER_CAPTION")
            }

            PathInput {
                id: installationPath

                property string bestPath: App.getExpectedInstallPath(currentGame.serviceId)

                y: 22
                width: root.width - 40
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
            anchors {
                left: parent.left
                leftMargin: 20
            }
            fontSize: 15
            checked: true
            text: qsTr("CREATE_DESKTOP_SHORTCUT")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }

        CheckBox {
            id: startMenuShortcut

            width: 300
            anchors {
                left: parent.left
                leftMargin: 20
            }
            fontSize: 15
            checked: true
            text: qsTr("CREATE_STARTMENU_SHORTCUT")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }

        Item {
            width: root.width
            height: 20

            Text {
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: 20
                    bottom: parent.bottom
                }
                text: qsTr("LICENSE_TIP")
                font {
                    family: 'Arial'
                    pixelSize: 12
                }
                color: '#5c6d7d'
                onLinkActivated: App.openExternalUrl(currentGame.licenseUrl)
            }
        }

        HorizontalSplit {
            width: root.width
            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Button {
            id: installButton

            ShakeAnimation {
                id: shakeAnimation

                target: installButton
                property: "anchors.leftMargin"
                from: 20
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
            anchors {
                left: parent.left
                leftMargin: 20
            }
            text: qsTr("INSTALL_BUTTON_CAPTION")
            onClicked: {
                licenseModel.setLicenseAccepted(true);
                licenseModel.setShurtCutInDesktop(desktopShortcut.checked);
                licenseModel.setShurtCutInStart(startMenuShortcut.checked);
                licenseModel.okPressed();

                if (root.currentGame.gameType != 'browser') {
                    App.setServiceInstallPath(root.currentGame.serviceId,
                                              installationPath.path,
                                              desktopShortcut.checked);
                }

                App.installService(currentGame.serviceId, {
                                                createDesktopShortCut: desktopShortcut.checked,
                                                createStartMenuShortCut: startMenuShortcut.checked
                                            });

                gameSettingsModelInstance.switchGame(currentGame.serviceId);

                root.close();
            }
        }
    }
}
