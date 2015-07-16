/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0

import "Pages"

PopupBase {
    id: root

    property variant currentGame: model ? model.currentGame : null
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance() || {}

    defaultMargins: 44
    width: 740
    title: qsTr("GAME_SETTINGS_TITLE").arg(App.currentGame().name)
    defaultBackgroundColor: Styles.applicationBackground

    onClose: {
        try {
            generalSettingsPage.load();
            overlaySettingsPage.load();
            controlSettingsPage.load();
        } catch (e) {
            console.log(e);
        }
    }

    Connections {
        target: SignalBus
        ignoreUnknownSignals: true

        onUninstallStarted: {
            if (root.currentGame.serviceId == serviceId) {
                root.close();
            }
        }
    }

    Item {
        width: parent.width - 1 + root.defaultMargins
        height: 340
        anchors {
            left: parent.left
            leftMargin: - root.defaultMargins + 1
        }

        Item {
            width: 188
            height: parent.height + 29

            Rectangle {
                anchors.fill: parent
                color: Styles.contentBackground
            }

            Column {
                anchors.fill: parent
                spacing: 1

                SettingsTextButton {
                     checked: root.state === "GeneralPage"
                     text: qsTr("FOLDERS_TAB")
                     analytics {
                         category: 'GameSettings'
                         label: 'GeneralPage'
                     }

                     onClicked: root.state = "GeneralPage";
                }

                SettingsTextButton {
                     checked: root.state === "OverlayPage"
                     text: qsTr("OVERLAY_TAB")
                     visible: !!root.currentGame && root.currentGame.hasOverlay
                     analytics {
                         category: 'GameSettings'
                         label: 'OverlayPage'
                     }
                     onClicked: root.state = "OverlayPage";
                }

                SettingsTextButton {
                    text: qsTr("UNINSTALL_GAME")

                    analytics {
                        category: 'GameSettings'
                        label: 'Uninstall'
                    }

                    onClicked: SignalBus.uninstallRequested(root.currentGame.serviceId);
                }

                SettingsTextButton {
                    text: qsTr("RESTORE_CLIENT")
                    analytics {
                        category: 'GameSettings'
                        label: 'Restore client'
                    }
                    onClicked: {
                        root.gameSettingsModelInstance.restoreClient();
                        root.currentGame.status = 'Normal';
                        SignalBus.navigate("mygame", '');
                        Popup.show('GameLoad');
                        root.close();
                    }

                    toolTip: qsTr("RESTORE_CLIENT_TOOLTIP")
                    tooltipPosition: "E"
                }

                /*
                SettingsTextButton {
                     checked: root.state === "ControlPage"
                     text: qsTr("CONTROLS_TAB")
                     analytics {
                        category: 'GameSettings'
                        action: 'Switch to ControlPage'
                     }
                     onClicked: root.state = "ControlPage";
                }
                */
            }
        }

        Item {
            x: 188
            width: parent.width - 188
            height: parent.height

            Switcher {
                id: pageSwitcher

                anchors.fill: parent

                GameGeneralSettings {
                    id: generalSettingsPage

                    anchors.fill: parent
                    currentItem: root.currentGame
                }

                GameOverlaySettings {
                    id: overlaySettingsPage

                    anchors.fill: parent
                    currentItem: root.currentGame
                }

                GameControlSettings {
                    id: controlSettingsPage

                    anchors.fill: parent
                }
            }

            PrimaryButton {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                analytics {
                    category: 'GameSettings'
                    label: 'Save'
                }

                width: 210
                text: qsTr("SAVE_BUTTON_LABEL")

                onClicked: {
                    try {
                        generalSettingsPage.save();
                        overlaySettingsPage.save();
                        controlSettingsPage.save();
                        gameSettingsModelInstance.submitSettings();
                    } catch (e) {
                        console.log(e);
                    }

                    root.close();
                }
            }
        }
    }

    state: "GeneralPage"
    states: [
        State {
            name: "GeneralPage"
            StateChangeScript {
                script: {
                    generalSettingsPage.load();
                    pageSwitcher.switchTo(generalSettingsPage);
                }
            }
        },
        State {
            name: "OverlayPage"

            StateChangeScript {
                script: {
                    overlaySettingsPage.load();
                    pageSwitcher.switchTo(overlaySettingsPage);
                }
            }
        },
        State {
            name: "ControlPage"
            StateChangeScript {
                script: {
                    controlSettingsPage.load();
                    pageSwitcher.switchTo(controlSettingsPage);
                }
            }
        }
    ]
}
