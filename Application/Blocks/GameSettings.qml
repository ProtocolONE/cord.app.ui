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
import "../Core/Popup.js" as Popup
import "../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Rectangle {
    id: root

    property variant currentGame: App.currentGame()
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance() || {}

    signal close();

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
        gameSettingsModelInstance.switchGame(currentGame.serviceId);
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
                        onClicked: {
                            root.state = "GeneralPage";

                            GoogleAnalytics.trackEvent('/ApplicationSettings',
                                                       'Navigation',
                                                       'Switch to GeneralPage');
                        }
                    }

                    TextButton {
                        text: qsTr("OVERLAY_TAB")
                        width: 160
                        height: (root.currentGame && root.currentGame.hasOverlay) ? 20 : 0
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        visible: !!root.currentGame && root.currentGame.hasOverlay
                        onClicked: {
                            root.state = "OverlayPage";

                            GoogleAnalytics.trackEvent('/ApplicationSettings',
                                                       'Navigation',
                                                       'Switch to OverlayPage');
                        }
                    }

                    TextButton {
                        text: qsTr("CONTROLS_TAB")
                        width: 160
                        height: 20
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: {
                            root.state = "ControlPage";

                            GoogleAnalytics.trackEvent('/ApplicationSettings',
                                                       'Navigation',
                                                       'Switch to ControlPage');
                        }
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
                    onClicked: {
                        gameSettingsModel.restoreClient();
                        App.navigate("mygame");
                        Popup.show('GameLoad');

                        GoogleAnalytics.trackEvent('/ApplicationSettings',
                                                   'Application',
                                                   'Restore client');
                    }
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
