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
import Application.Blocks.ApplicationSettings 1.0

import "../Core/App.js" as App

Rectangle {
    id: root

    signal accepted()

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
                        checkable: true
                        checked: root.state === "GeneralPage"
                        text: qsTr("GENERAL_TAB")
                        width: 160
                        height: 20
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                            active: "#000000"
                        }
                        onClicked: root.state = "GeneralPage";
                    }

                    TextButton {
                        checkable: true
                        checked: root.state === "DownloadsPage"
                        text: qsTr("DOWNLOADS_TAB")
                        width: 160
                        height: 20
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                            active: "#000000"
                        }
                        onClicked: root.state = "DownloadsPage";
                    }

                    TextButton {
                        checkable: true
                        checked: root.state === "NotificationsPage"
                        text: qsTr("NOTIFICATIONS_TAB")
                        width: 160
                        height: 20
                        style: ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                            active: "#000000"
                        }
                        onClicked: root.state = "NotificationsPage";
                    }

                }

                TextButton {
                    width: 150
                    height: 30
                    anchors {
                        bottom: parent.bottom
                    }
                    font {
                        family: 'Arial'
                        pixelSize: 15
                    }
                    wrapMode: Text.WordWrap
                    text: qsTr("RESTORE_SETTINGS")
                    style: ButtonStyleColors {
                        normal: "#1ADC9C"
                        hover: "#019074"
                    }
                    onClicked: {
                        settingsViewModel.setDefaultSettings();
                        App.selectLanguage("ru");
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
                }

                Button {
                    width: 200
                    height: 48
                    text: qsTr("OK_BUTTON_LABEL")
                    anchors {
                        left: parent.left
                        leftMargin: 30
                        bottom: parent.bottom
                    }
                    onClicked: {
                        generalSettingsPage.save();
                        downloadSettingsPage.save();
                        notificationSettingsPage.save();

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
            name: "DownloadsPage"

            StateChangeScript {
                script: pageSwitcher.switchTo(downloadSettingsPage);
            }
        },
        State {
            name: "NotificationsPage"
            StateChangeScript {
                script: pageSwitcher.switchTo(notificationSettingsPage);
            }
        }
    ]
}

