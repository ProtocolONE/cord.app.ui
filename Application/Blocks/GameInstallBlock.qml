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
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Blocks 1.0

import "../Core/App.js" as App
import "../Core/Popup.js" as Popup
import "../Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    property variant gameItem: App.currentGame()

    width: 180
    height: button.isStartDownloading ? 136 : 100

    Behavior on height {
        NumberAnimation { id: heightAnimation; duration: 250 }
    }

    Connections {
        target: licenseModel

        onOpenLicenseBlock: {
            // TODO подумать куда это вынести
            var gameItem = App.serviceItemByServiceId(licenseModel.serviceId());
            App.navigate("mygame");
            App.activateGame(gameItem);
            Popup.show('GameInstall');
            licenseModel.setLicenseAccepted(false);
        }
    }

    Rectangle {
        anchors.fill: parent
        color: '#082135'
    }

    Item {
        anchors {
            fill: parent
            margins: 10
        }

        Column {
            id: column

            anchors.fill: parent
            spacing: 5

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 18
                }

                color: '#ffffff'
                text: root.gameItem.name
            }

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 12
                }

                color: '#597082'
                text: root.gameItem.shortDescription
            }

            Button {
                id: button

                width: 160
                height: 35

                property bool isInstalled: App.isServiceInstalled(root.gameItem.serviceId)
                property bool isStartDownloading: root.gameItem.status === "Downloading"
                property bool isError: root.gameItem.status === "Error"
                property bool isPause: root.gameItem.status === "Paused"
                property bool allreadyDownloaded: root.gameItem.allreadyDownloaded

                property string buttonNotInstalledText: qsTr("BUTTON_PLAY_NOT_INSTALLED")
                property string buttonText: qsTr("BUTTON_PLAY_DEFAULT_STATE")
                property string buttonPauseText: qsTr("BUTTON_PLAY_ON_PAUSE_STATE")
                property string buttonDownloadText: qsTr("BUTTON_PLAY_DOWNLOADING_NOW_STATE")
                property string buttonDownloadedText: qsTr("BUTTON_PLAY_DOWNLOADED_AND_READY_STATE")

                text: isPause ? buttonPauseText
                              : allreadyDownloaded ? buttonDownloadedText
                                                   : isError ? buttonErrorText
                                                             : isStartDownloading ? buttonDownloadText
                                                                                  : isInstalled ?
                                                                                    buttonText : buttonNotInstalledText
                style: ButtonStyleColors {
                    property bool isDefaultColor: root.gameItem.status === "Normal" && !button.isInstalled

                    normal: isDefaultColor ? "#ff4f02" : "#567dd8"
                    hover: isDefaultColor ? "#ff7902" : "#5e89ee"
                }

                onClicked: {
                    var status = root.gameItem.status,
                        serviceId = root.gameItem.serviceId;

                    if (button.isStartDownloading) {
                        App.downloadButtonPause(serviceId);

                        // LETS THINK - 'Big Green' это action старой кнопки, подумать нужно ли менять на новое
                        if (root.gameItem) {
                            GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName,
                                                       'Game ' + root.gameItem.gaName, 'Pause', 'Big Green');
                        }
                    } else {
                        App.downloadButtonStart(serviceId);
                        if (root.gameItem) {
                            GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName,
                                                       'Game ' + root.gameItem.gaName, 'Play', 'Big Green');
                        }
                    }
                }
            }
        }

        DownloadStatus {
            id: downloadStatus

            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 25
            serviceItem: root.gameItem
            textColor: '#597082'
            spacing: 6
            opacity: button.isStartDownloading && !heightAnimation.running ? 1 : 0 // TODO добавить анимацию прозрачности
        }
    }
}
