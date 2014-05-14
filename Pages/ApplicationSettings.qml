import QtQuick 1.1

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
import "../Controls" as Controls
import "../Blocks2/ApplicationSettings" as SettingsBlocks

Rectangle {
    id: root

    signal accepted()
    signal restoreClient()

    Column {
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

                    Controls.TextButton {
                        text: qsTr("GENERAL_TAB")
                        width: 160
                        height: 20
                        style: Controls.ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: root.state = "GeneralPage";
                    }

                    Controls.TextButton {
                        text: qsTr("DOWNLOADS_TAB")
                        width: 160
                        height: 20
                        style: Controls.ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: root.state = "DownloadsPage";
                    }

                    Controls.TextButton {
                        text: qsTr("NOTIFICATIONS_TAB")
                        width: 160
                        height: 20
                        style: Controls.ButtonStyleColors {
                            normal: "#3498BD"
                            hover: "#3670DC"
                        }
                        onClicked: root.state = "NotificationsPage";
                    }

                }

                Controls.TextButton {
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
                    style: Controls.ButtonStyleColors {
                        normal: "#1ADC9C"
                        hover: "#019074"
                    }
                }

            }

            Controls.VerticalSplit {
                x: 219
                height: 422
                style: Controls.SplitterStyleColors {
                    main: "#CCCCCC"
                    shadow: "#FFFFFF"
                }
            }

            Rectangle {
                x: 220
                y: 2
                width: 529
                height: 422

                Controls.Switcher {
                    id: pageSwitcher

                    SettingsBlocks.GeneralSettings {
                        id: generalSettingsPage

                        width: 529
                        height: 422
                    }
                    SettingsBlocks.DownloadSettings {
                        id: downloadSettingsPage

                        width: 529
                        height: 422
                    }
                    SettingsBlocks.NotificationSettings {
                        id: notificationSettingsPage

                        width: 529
                        height: 422
                    }
                }

                Controls.Button {
                    width: 200
                    height: 48
                    text: qsTr("OK_BUTTON_LABEL")
                    anchors {
                        left: parent.left
                        leftMargin: 30
                        bottom: parent.bottom
                    }
                    onClicked: root.accepted();
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

