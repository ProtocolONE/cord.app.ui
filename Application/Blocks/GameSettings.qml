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
import Application.Blocks.GameSettings 1.0

import "../Core/App.js" as App

Rectangle {
    id: root

    property variant currentGame: App.currentGame()
    signal accepted()

    onCurrentGameChanged: {
        // UNDONE: Вообще надо бы перенести куда то в другое место
        if (!currentGame) {
            return;
        }

        gameSettingsModel.switchGame(currentGame.serviceId);
    }

    CursorMouseArea {
        cursor: CursorArea.DefaultCursor
        anchors.fill: parent
    }

    Column {
        width: parent.width
        height: parent.height

        Rectangle {
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
                color: '#343537'
                smooth: true
            }
        }

        Rectangle {
            width: parent.width
            height: 421

            Item {
                x: 40
                width: 219
                height: 422

                Column {
                    spacing: 12

                    TextButton {
                        text: qsTr("FOLDERS_TAB")
                        width: 160
                        height: 20
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: root.state = "GeneralPage";
                    }

                    TextButton {
                        text: qsTr("OVERLAY_TAB")
                        width: 160
                        height: (root.currentGame && root.currentGame.hasOverlay) ? 20 : 0
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        visible: root.currentGame && root.currentGame.hasOverlay
                        onClicked: root.state = "OverlayPage";
                    }

                    TextButton {
                        text: qsTr("CONTROLS_TAB")
                        width: 160
                        height: 20
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: root.state = "ControlPage";
                    }

                }

                TextButton {
                    width: 150
                    height: 15
                    anchors {
                        bottom: parent.bottom
                    }
                    font {
                        family: 'Arial'
                        pixelSize: 15
                    }
                    wrapMode: Text.WordWrap
                    text: qsTr("RESTORE_CLIENT")
                    style: ButtonStyleColors {
                        normal: "#1ADC9C"
                        hover: "#019074"
                    }
                    onClicked: gameSettingsModel.restoreClient();
                }
            }

            VerticalSplit {
                x: 219
                height: 422
                style: SplitterStyleColors {
                    main: "#CCCCCC"
                    shadow: "#FFFFFF"
                }
            }

            Rectangle {
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

                Button {
                    width: 200
                    height: 48
                    text: "Ok"
                    anchors {
                        left: parent.left
                        leftMargin: 30
                        bottom: parent.bottom
                    }
                    onClicked: {
                        generalSettingsPage.save();
                        overlaySettingsPage.save();
                        controlSettingsPage.save();

                        gameSettingsModel.submitSettings();
                        root.accepted();
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
                script: pageSwitcher.switchTo(generalSettingsPage);
            }
        },
        State {
            name: "OverlayPage"

            StateChangeScript {
                script: pageSwitcher.switchTo(overlaySettingsPage);
            }
        },
        State {
            name: "ControlPage"
            StateChangeScript {
                script: pageSwitcher.switchTo(controlSettingsPage);
            }
        }
    ]
}
