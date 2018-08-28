import QtQuick 2.4
import Tulip 1.0
import GameNet.Controls 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

import "Pages"

PopupBase {
    id: root

    property string paramHash: ""

    function reloadSettings() {
        try {
            generalSettingsPage.load();
            downloadSettingsPage.load();
            notificationSettingsPage.load();
            //messengerSettingsPage.load();
            blacklistPage.load();
        } catch (e) {
            console.log(e)
        }

        var params = root.getMarketingsParams();
        root.paramHash = JSON.stringify(params);
    }

    function resetSettings() {
        generalSettingsPage.reset();
        downloadSettingsPage.reset();
        notificationSettingsPage.reset();
        //messengerSettingsPage.reset();
        blacklistPage.reset();
    }

    function save() {
        try {
            generalSettingsPage.save();
            downloadSettingsPage.save();
            notificationSettingsPage.save();
            //messengerSettingsPage.save();
            blacklistPage.save();
        } catch (e) {
            console.log(e);
        }

        root.sendMarketings();
        root.close();
    }

    function getMarketingsParams() {
        var result = {};
        generalSettingsPage.setMarketingsParams(result);
        downloadSettingsPage.setMarketingsParams(result);
        notificationSettingsPage.setMarketingsParams(result);
        //messengerSettingsPage.setMarketingsParams(result);
        return result;
    }

    function sendMarketings() {
        var params = root.getMarketingsParams();
        var paramHash = JSON.stringify(params);
        if (root.paramHash == paramHash) {
            return;
        }

        params.downloadSettingsChanged = downloadSettingsPage.changed() ? "0" : "1"
        params.userId = User.userId();

        Marketing.send(Marketing.ApplicationSettingsChanged, "0", params);
    }

    function navigateTo(pageName) {
        root.state = pageName;
    }

    defaultMargins: 44
    title: qsTr("APPLICATION_SETTINGS_TITLE")
    width: 900
    defaultBackgroundColor: Styles.applicationBackground
    Component.onCompleted: root.reloadSettings();

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
                color: Styles.contentBackground
            }

            Column {
                anchors.fill: parent
                spacing: 1

                SettingsTextButton {
                    checked: root.state === "GeneralPage"
                    text: qsTr("GENERAL_TAB")
                    analytics {
                        category: 'ApplicationSettings'
                        action: 'Switch to GeneralPage'
                    }
                    onClicked: root.state = "GeneralPage";
                }

                SettingsTextButton {
                    checked: root.state === "DownloadsPage"
                    text: qsTr("DOWNLOADS_TAB")
                    analytics {
                        category: 'ApplicationSettings'
                        action: 'Switch to DownloadsPage'
                    }
                    onClicked: root.state = "DownloadsPage";
                }

                SettingsTextButton {
                    checked: root.state === "NotificationsPage"
                    text: qsTr("NOTIFICATIONS_TAB")
                    analytics {
                        category: 'ApplicationSettings'
                        action: 'Switch to NotificationPage'
                    }
                    onClicked: root.state = "NotificationsPage";
                }

//                SettingsTextButton {
//                    checked: root.state === "MessengerPage"
//                    text: qsTr("MESSENGER_TAB")
//                    analytics {
//                        category: 'ApplicationSettings'
//                        action: 'Switch to MessengerPage'
//                    }
//                    onClicked: root.state = "MessengerPage";
//                }

                SettingsTextButton {
                    checked: root.state === "BlacklistPage"
                    text: qsTr("Черный список")
                    analytics {
                        category: 'ApplicationSettings'
                        action: 'Switch to BlacklistPage'
                    }
                    onClicked: root.state = "BlacklistPage";
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

//                MessengerSettings {
//                    id: messengerSettingsPage

//                    anchors.fill: parent
//                }

                Blacklist {
                    id: blacklistPage

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
                    category: 'ApplicationSettings'
                    label: 'Restore default'
                }

                onClicked: root.resetSettings();
                icon: installPath + Styles.applicationSettingsDefaultSettingsIcon
            }

            PrimaryButton {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }
                analytics {
                    category: 'ApplicationSettings'
                    label: 'Save'
                }

                width: 210
                text: qsTr("SAVE_BUTTON_LABEL")
                onClicked: root.save();
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
//        State {
//            name: "MessengerPage"
//            StateChangeScript {
//                script: {
//                    pageSwitcher.switchTo(messengerSettingsPage);
//                }
//            }
//        },
        State {
            name: "BlacklistPage"
            StateChangeScript {
                script: {
                    pageSwitcher.switchTo(blacklistPage);
                }
            }
        }
    ]

}
