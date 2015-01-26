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
import Tulip 1.0
import GameNet.Controls 1.0

import "./Settings"
import "./Settings/Application"

import "../Core/App.js" as App
import "../Core/Styles.js" as Styles

Rectangle {
    id: root

    signal close()

    function reloadSettings() {
        try {
            generalSettingsPage.load();
            downloadSettingsPage.load();
            notificationSettingsPage.load();
            messengerSettingsPage.load();
        } catch (e) {
            console.log(e)
        }
    }

    function resetSettings() {
        generalSettingsPage.reset();
        downloadSettingsPage.reset();
        notificationSettingsPage.reset();
        messengerSettingsPage.reset();
    }

    color: Styles.style.settingsBackground

    Connections {
        target: App.signalBus();
        onNavigate: {
            if (link === "ApplicationSettings") {
                root.reloadSettings();
            }
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
                text: qsTr("APPLICATION_SETTINGS_TITLE")
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
                        text: qsTr("GENERAL_TAB")
                        analytics {
                            page: '/ApplicationSettings'
                            action: 'Switch to GeneralPage'
                        }
                        onClicked: root.state = "GeneralPage";
                    }

                    SettingsTextButton {
                        checked: root.state === "DownloadsPage"
                        text: qsTr("DOWNLOADS_TAB")
                        analytics {
                            page: '/ApplicationSettings'
                            action: 'Switch to DownloadsPage'
                        }
                        onClicked: root.state = "DownloadsPage";
                    }

                    SettingsTextButton {
                        checked: root.state === "NotificationsPage"
                        text: qsTr("NOTIFICATIONS_TAB")
                        analytics {
                            page: '/ApplicationSettings'
                            action: 'Switch to NotificationPage'
                        }
                        onClicked: root.state = "NotificationsPage";
                    }

                    SettingsTextButton {
                        checked: root.state === "MessengerPage"
                        text: qsTr("MESSENGER_TAB")
                        analytics {
                            page: '/ApplicationSettings'
                            action: 'Switch to MessengerPage'
                        }
                        onClicked: root.state = "MessengerPage";
                    }
                }

                SettingsSpecialButton {
                    width: 150
                    height: 30
                    anchors { bottom: parent.bottom }
                    text: qsTr("RESTORE_SETTINGS")
                    analytics {
                        page: '/ApplicationSettings'
                        category: 'Settings'
                        action: 'Restore default settings'
                    }

                    onClicked: root.resetSettings();
                }
            }

            SettingsVerticalSplit {
                x: 219
                height: 422
            }

            Item {
                x: 220
                y: 2
                width: 529
                height: 422

                Switcher {
                    id: pageSwitcher

                    anchors.fill: parent

                    GeneralSettings {
                        id: generalSettingsPage

                        anchors.fill: parent
                    }
                    DownloadSettings {
                        id: downloadSettingsPage

                        anchors.fill: parent
                    }
                    NotificationSettings {
                        id: notificationSettingsPage

                        anchors.fill: parent
                    }
                    MessengerSettings {
                        id: messengerSettingsPage

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
                                downloadSettingsPage.save();
                                notificationSettingsPage.save();
                                messengerSettingsPage.save();
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
                    pageSwitcher.switchTo(generalSettingsPage);
                }
            }
        },
        State {
            name: "DownloadsPage"

            StateChangeScript {
                script: {
                    pageSwitcher.switchTo(downloadSettingsPage);
                }
            }
        },
        State {
            name: "NotificationsPage"
            StateChangeScript {
                script: {
                    pageSwitcher.switchTo(notificationSettingsPage);
                }
            }
        },
        State {
            name: "MessengerPage"
            StateChangeScript {
                script: {
                    pageSwitcher.switchTo(messengerSettingsPage);
                }
            }
        }
    ]
}

