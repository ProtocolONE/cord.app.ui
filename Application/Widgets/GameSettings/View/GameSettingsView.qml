import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0

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

    property variant gameWithSettings: []

    property bool notBrowser: !!root.currentGame && root.currentGame.gameType !== "browser"

    function hasGameSettings(serviceId) {
        var i;

        for (i = 0; i < gameWithSettings.length; ++i) {
            if (serviceId == gameWithSettings[i]) {
                return true;
            }
        }

        return false;
    }

    defaultMargins: 44
    width: root.notBrowser ? 740 : 600
    title: qsTr("GAME_SETTINGS_TITLE").arg(App.currentGame().name)
    defaultBackgroundColor: Styles.applicationBackground

    onClose: {
        try {
            generalSettingsPage.load();
            //overlaySettingsPage.load();
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
        height: root.notBrowser ? 440 : 220
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
                     text: root.notBrowser ? qsTr("FOLDERS_TAB") : qsTr("SHORTCUT_TAB")
                     analytics {
                         category: 'GameSettings'
                         label: 'GeneralPage'
                     }

                     onClicked: root.state = "GeneralPage";
                }

                SettingsTextButton {
                     checked: root.state === "ControlPage"
                     text: qsTr("Игровые настройки")
                     visible: !!root.currentGame && root.hasGameSettings(root.currentGame.serviceId)
                     analytics {
                        category: 'GameSettings'
                        action: 'ControlPage'
                     }
                     onClicked: root.state = "ControlPage";
                }

//                SettingsTextButton {
//                     checked: root.state === "OverlayPage"
//                     text: qsTr("OVERLAY_TAB")
//                     visible: !!root.currentGame && root.currentGame.hasOverlay
//                     analytics {
//                         category: 'GameSettings'
//                         label: 'OverlayPage'
//                     }
//                     onClicked: root.state = "OverlayPage";
//                }

                SettingsTextButton {
                    visible: root.notBrowser
                    text: qsTr("UNINSTALL_GAME")

                    analytics {
                        category: 'GameSettings'
                        label: 'Uninstall'
                    }

                    onClicked: SignalBus.uninstallRequested(root.currentGame.serviceId);
                }

                SettingsTextButton {
                    visible: root.notBrowser
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
                    visible: root.notBrowser
                }

//                GameOverlaySettings {
//                    id: overlaySettingsPage

//                    anchors.fill: parent
//                    currentItem: root.currentGame
//                }

                GameControlSettings {
                    id: controlSettingsPage

                    anchors.fill: parent
                    currentItem: root.currentGame
                }
            }

            PrimaryButton {
                function isRunning() {
                    return root.currentGame
                            && (root.currentGame.status === "Starting" || root.currentGame.status === "Started");
                }

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

                enabled: !isRunning()
                onClicked: {
                    try {
                        generalSettingsPage.save();
                        //overlaySettingsPage.save();
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
//        State {
//            name: "OverlayPage"

//            StateChangeScript {
//                script: {
//                    overlaySettingsPage.load();
//                    pageSwitcher.switchTo(overlaySettingsPage);
//                }
//            }
//        },
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
