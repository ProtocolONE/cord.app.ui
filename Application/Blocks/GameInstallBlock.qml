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
    height: button.isStartDownloading || button.isStarting ? 137 : 101

    Behavior on height {
        NumberAnimation { id: heightAnimation; duration: 250 }
    }

    Connections {
        target: licenseModel

        onOpenLicenseBlock: {
            // TODO подумать куда это вынести
            var gameItem = App.serviceItemByServiceId(licenseModel.serviceId());
            App.activateGame(gameItem);
            Popup.show('GameInstall');
            licenseModel.setLicenseAccepted(false);
        }
    }

    Connections {
        target: App.signalBus()
        onNavigate: {
            if (link == 'mygame' && from == 'GameItem' &&
                    !App.isAppSettingsEnabled("qml/installBlock/", "shakeAnimationShown", false)) {
                App.setAppSettingsValue("qml/installBlock/", "shakeAnimationShown", true);
                shakeAnimationTimer.start();
            }
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

                function testStarted() {
                    if (!root.gameItem) {
                        return false;
                    }

                    if (root.gameItem.gameType == "browser") {
                        return false;
                    }

                    var currentMainRunning = App.currentRunningMainService();
                    var currentSecondRunning = App.currentRunningSecondService();
                    if (currentMainRunning ||
                            currentSecondRunning && currentSecondRunning != root.gameItem.serviceId) {
                        return true;
                    }

                    return false;
                }

                property bool isInstalled: App.isServiceInstalled(root.gameItem.serviceId)
                property bool isStartDownloading: root.gameItem.status === "Downloading"
                property bool isStarting: root.gameItem.status === "Starting"
                property bool isError: root.gameItem.status === "Error"
                property bool isPause: root.gameItem.status === "Paused"
                property bool isDetailed: root.gameItem.status === "Paused"
                property bool allreadyDownloaded: root.gameItem.allreadyDownloaded

                property string buttonNotInstalledText: qsTr("BUTTON_PLAY_NOT_INSTALLED")
                property string buttonText: qsTr("BUTTON_PLAY_DEFAULT_STATE")
                property string buttonDetailsText: qsTr("BUTTON_PLAY_ON_DETAILS_STATE")
                property string buttonDownloadText: qsTr("BUTTON_PLAY_DOWNLOADING_NOW_STATE")
                property string buttonDownloadedText: qsTr("BUTTON_PLAY_DOWNLOADED_AND_READY_STATE")

                width: 160
                height: 35

                enabled: !testStarted()

                text: allreadyDownloaded ? buttonDownloadedText
                                         : isStartDownloading ? buttonDetailsText
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
                        Popup.show('GameLoad');
                    } else {
                        App.downloadButtonStart(serviceId);
                        if (root.gameItem) {
                            GoogleAnalytics.trackEvent('/game/' + root.gameItem.gaName,
                                                       'Game ' + root.gameItem.gaName, 'Play', 'Big Green');
                        }
                    }
                }

                ShakeAnimation {
                    id: shakeAnimation

                    target: button
                    property: "x"
                    from: 0
                    shakeValue: 2
                    shakeTime: 120
                }

                Timer {
                    id: shakeAnimationTimer

                    interval: 1500
                    onTriggered: shakeAnimation.start();
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
            opacity: (button.isStartDownloading || button.isStarting) && !heightAnimation.running ?
                         1 : 0 // TODO добавить анимацию прозрачности
        }
    }
}
