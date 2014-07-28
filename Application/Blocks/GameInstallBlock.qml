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
import "../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    property variant gameItem: App.currentGame()
    property bool isFullSize: button.isStartDownloading || button.isStarting || button.isError

    width: 180
    height: root.isFullSize ? 137 : 101

    Behavior on height {
        NumberAnimation { id: heightAnimation; duration: 250 }
    }

    Connections {
        target: App.signalBus()
        onNavigate: {
            if (link == 'mygame'
                    && from == 'GameItem'
                    && !root.isFullSize
                    && !App.isAppSettingsEnabled("qml/installBlock/", "shakeAnimationShown", false)) {
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
                text: root.gameItem ? root.gameItem.name : ""
            }

            Text {
                font {
                    family: 'Arial'
                    pixelSize: 12
                }

                color: '#597082'
                text: root.gameItem ? root.gameItem.shortDescription : ""
            }

            Button {
                id: button

                function getText() {
                    if (isError) {
                        return buttonErrorText;
                    }

                    if (isPause) {
                        return qsTr("BUTTON_PLAY_ON_PAUSED_STATE");
                    }

                    if (allreadyDownloaded) {
                        return buttonDownloadedText;
                    }

                    if (isStartDownloading) {
                        return buttonDetailsText;
                    }

                    if (isInstalled) {
                        return buttonText;
                    }

                    return buttonNotInstalledText;
                }

                property bool isInstalled: root.gameItem ? (App.isServiceInstalled(root.gameItem.serviceId)) : false
                property bool isStartDownloading: root.gameItem ? (root.gameItem.status === "Downloading") : false
                property bool isStarting: root.gameItem ? (root.gameItem.status === "Starting") : false
                property bool isError: root.gameItem ? (root.gameItem.status === "Error") : false
                property bool isPause: root.gameItem ? (root.gameItem.status === "Paused") : false
                property bool isDetailed: root.gameItem ? (root.gameItem.status === "Paused") : false
                property bool allreadyDownloaded: root.gameItem ? (root.gameItem.allreadyDownloaded) : false

                property string buttonNotInstalledText: qsTr("BUTTON_PLAY_NOT_INSTALLED")
                property string buttonText: qsTr("BUTTON_PLAY_DEFAULT_STATE")
                property string buttonDetailsText: qsTr("BUTTON_PLAY_ON_DETAILS_STATE")
                property string buttonDownloadText: qsTr("BUTTON_PLAY_DOWNLOADING_NOW_STATE")
                property string buttonDownloadedText: qsTr("BUTTON_PLAY_DOWNLOADED_AND_READY_STATE")
                property string buttonErrorText: qsTr("BUTTON_PLAY_ERROR_STATE")

                width: 160
                height: 35

                enabled: App.isMainServiceCanBeStarted(root.gameItem)
                text: button.getText()

                focus: true

                style: ButtonStyleColors {
                    normal: button.isError ? "#cc0000" : "#ff4f02"
                    hover: button.isError ? "#ee0000" : "#ff7902"
                    disabled: '#888888'
                }

                onClicked: {
                    if (!root.gameItem) {
                        return;
                    }

                    if (root.gameItem.maintenance) {
                        button.forceActiveFocus();
                    }

                    if (button.isError) {
                        Popup.show('GameDownloadError');
                        return;
                    }

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

            function isVisible() {
                if (heightAnimation.running) {
                    return false;
                }

                return root.isFullSize;
            }

            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 25
            serviceItem: root.gameItem
            textColor: '#597082'
            spacing: 6
            opacity: downloadStatus.isVisible() ? 1 : 0// TODO добавить анимацию прозрачности
        }
    }
}
