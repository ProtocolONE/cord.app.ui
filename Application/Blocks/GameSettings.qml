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

import "./Settings"
import "./Settings/Game"

import "../Core/App.js" as App
import "../Core/Popup.js" as Popup
import "../Core/Styles.js" as Styles

Rectangle {
    id: root

    property variant currentGame: App.currentGame()
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance() || {}

    signal close();

    color: Styles.style.settingsBackground
    onClose: {
        try {
            generalSettingsPage.load();
            overlaySettingsPage.load();
            controlSettingsPage.load();
        } catch (e) {
            console.log(e);
        }
    }

    onCurrentGameChanged: {
        // UNDONE: Вообще надо бы перенести куда то в другое место
        if (!currentGame) {
            return;
        }

        root.state = "GeneralPage";
        if (root.gameSettingsModelInstance && root.gameSettingsModelInstance.switchGame) {
            root.gameSettingsModelInstance.switchGame(currentGame.serviceId);
        }
    }

    CursorMouseArea {
        cursor: CursorArea.DefaultCursor
        anchors.fill: parent
    }

    Column {
        width: parent.width
        height: parent.height

        Item {
            id: headerRect

            width: parent.width
            height: 93

            Text {
                text: qsTr("GAME_SETTINGS_TITLE").arg(qsTr(!!root.currentGame ? root.currentGame.name : ""));
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 40
                }
                font {
                    family: 'Arial'
                    pixelSize: 20
                }
                color: Styles.style.settingsTitleText
                smooth: true
            }
        }

        Item {
            width: parent.width
            height: 421

            Item {
                x: 40
                width: 219
                height: 422

                Column {
                    spacing: 12

                    SettingsTextButton {
                         checked: root.state === "GeneralPage"
                         text: qsTr("FOLDERS_TAB")
                         analytics {
                            page: '/GameSettings'
                            action: 'Switch to GeneralPage'
                         }

                         onClicked: root.state = "GeneralPage";
                    }

                    SettingsTextButton {
                         checked: root.state === "OverlayPage"
                         text: qsTr("OVERLAY_TAB")
                         height: (root.currentGame && root.currentGame.hasOverlay) ? 20 : 0
                         visible: !!root.currentGame && root.currentGame.hasOverlay
                         analytics {
                            page: '/GameSettings'
                            action: 'Switch to OverlayPage'
                         }
                         onClicked: root.state = "OverlayPage";
                    }

                    /*
                    SettingsTextButton {
                         checked: root.state === "ControlPage"
                         text: qsTr("CONTROLS_TAB")
                         analytics {
                            page: '/GameSettings'
                            action: 'Switch to ControlPage'
                         }
                         onClicked: root.state = "ControlPage";
                    }
                    */
                }

                SettingsSpecialButton {
                    width: 150
                    height: 30
                    enabled: !(App.currentRunningMainService() || App.currentRunningSecondService())
                    visible: currentGame ? currentGame.serviceId != "30000000000" : false //INFO F&F Hack
                    anchors { bottom: parent.bottom }
                    text: qsTr("RESTORE_CLIENT")
                    analytics {
                        page: '/GameSettings'
                        category: 'Settings'
                        action: 'Restore client'
                    }
                    onClicked: {
                        gameSettingsModel.restoreClient();
                        root.currentGame.status = 'Normal';
                        App.navigate("mygame");
                        Popup.show('GameLoad');
                    }
                }
            }

            SettingsVerticalSplit {
                x: 219
                height: 422
            }

            Item {
                x: 220
                width: 529
                height: 424

                Switcher {
                    id: pageSwitcher

                    anchors.fill: parent

                    GameGeneralSettings {
                        id: generalSettingsPage

                        anchors.fill: parent
                    }

                    GameOverlaySettings {
                        id: overlaySettingsPage

                        anchors.fill: parent
                    }

                    GameControlSettings {
                        id: controlSettingsPage

                        anchors.fill: parent
                    }
                }

                Row {
                    anchors {
                        left: parent.left
                        leftMargin: 30
                        bottom: parent.bottom
                    }
                    width: 500
                    height: 50
                    spacing: 20

                    Button {
                        width: 200
                        height: 48
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

                    Button {
                        width: 200
                        height: 48
                        text: qsTr("CLOSE_BUTTON_LABEL")
                        onClicked: root.close();
                    }
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
