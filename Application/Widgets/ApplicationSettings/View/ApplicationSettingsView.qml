import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import "Pages"
import "../../../Core/App.js" as App
import "../../../Core/Popup.js" as Popup
import "../../../Core/Styles.js" as Styles
import "../../../Core/User.js" as User
import "../../../Core/MessageBox.js" as MessageBox

PopupBase {
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

    defaultMargins: 44
    title: qsTr("APPLICATION_SETTINGS_TITLE")
    width: 900
    defaultBackgroundColor: Styles.style.applicationBackground

    Connections {
        target: App.signalBus();
        onNavigate: {
            if (link === "ApplicationSettings") {
                root.reloadSettings();
            }
        }
    }

    Item {
        width: parent.width - 1 + root.defaultMargins
        height: 420
        anchors {
            left: parent.left
            leftMargin: - root.defaultMargins + 1
        }

        Item {
            width: 188
            height: parent.height + 29

            Rectangle {
                anchors.fill: parent
                color: Styles.style.contentBackground
            }

            Column {
                anchors.fill: parent
                spacing: 1

                SettingsTextButton {
                    checked: root.state === "GeneralPage"
                    text: qsTr("GENERAL_TAB")
                    analytics {
                        page: '/ApplicationSettings'
                        category: "Settings"
                        action: 'Switch to GeneralPage'
                    }
                    onClicked: root.state = "GeneralPage";
                }

                SettingsTextButton {
                    checked: root.state === "DownloadsPage"
                    text: qsTr("DOWNLOADS_TAB")
                    analytics {
                        page: '/ApplicationSettings'
                        category: "Settings"
                        action: 'Switch to DownloadsPage'
                    }
                    onClicked: root.state = "DownloadsPage";
                }

                SettingsTextButton {
                    checked: root.state === "NotificationsPage"
                    text: qsTr("NOTIFICATIONS_TAB")
                    analytics {
                        page: '/ApplicationSettings'
                        category: "Settings"
                        action: 'Switch to NotificationPage'
                    }
                    onClicked: root.state = "NotificationsPage";
                }

                SettingsTextButton {
                    checked: root.state === "MessengerPage"
                    text: qsTr("MESSENGER_TAB")
                    analytics {
                        page: '/ApplicationSettings'
                        category: "Settings"
                        action: 'Switch to MessengerPage'
                    }
                    onClicked: root.state = "MessengerPage";
                }

            }
        }

        Item {
            x: 188
            width: parent.width - 188
            height: parent.height

            Switcher {
                id: pageSwitcher

                anchors {
                    fill: parent
                    leftMargin: 30
                }

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

            PopupHorizontalSplit {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 60
                    left: parent.left
                    leftMargin: 30
                    right: parent.right
                    rightMargin: 30
                }
            }

            TextButton {
                x: 30
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 20-8
                }
                text: qsTr("RESTORE_SETTINGS")
                analytics {
                    page: '/ApplicationSettings'
                    category: 'Settings'
                    action: 'Restore default settings'
                }

                onClicked: root.resetSettings();
                icon: installPath + "Assets/Images/Application/Widgets/ApplicationSettings/defaultSettings.png"
            }

            PrimaryButton {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                width: 210
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
