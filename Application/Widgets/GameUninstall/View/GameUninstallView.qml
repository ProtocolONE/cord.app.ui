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

import Application.Blocks 1.0
import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import GameNet.Controls 1.0

import "../../../Core/App.js" as App
import "../../../Core/Styles.js" as Styles

PopupBase {
    id: root

    property variant gameItem: App.currentGame()

    Connections {
        target: App.signalBus()

        ignoreUnknownSignals: true

        onUninstallFinished: {
            if (!root.gameItem) {
                return;
            }

            if (root.gameItem.serviceId != serviceId) {
                return;
            }

            closeDelay.restart();
        }
    }

    QtObject {
        id: d

        property bool uninstallComplete: false

        function getStatusText() {
            if (!root.gameItem) {
                return "";
            }

            if (closeDelay.running) {
               return qsTr("UNINSTALL_COMPLETE").arg(root.gameItem.name);
            }

            return root.gameItem.statusText;
        }
    }

    title: qsTr("UNINSTALL_TITLE").arg(root.currentUninstallingItem ? root.currentUninstallingItem.name : "");
    height: 175
    clip: true

    Item {
        width: root.width
        height: parent.height

        Column {
            anchors {
                fill: parent
                margins: 20
                topMargin: 45
            }

            Item {
                id: centerBlock

                width: parent.width

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 14
                    }
                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: 15
                    }

                    smooth: true
                    color: defaultTextColor
                    text: d.getStatusText();
                }

                Rectangle {
                    width: parent.width
                    height: 22
                    color: Styles.style.gameUninstallWidgetBackground
                    border { color: Styles.style.gameUninstallWidgetBorder }

                    anchors {
                        top: parent.top
                        topMargin: 40
                    }

                    ProgressBar {
                        anchors {
                            fill: parent
                            margins: 6
                        }
                        style {
                            background: Styles.style.gameUninstallWidgetProgressBackground
                            line: Styles.style.gameUninstallWidgetProgressLine
                        }

                        progress: root.gameItem ? root.gameItem.progress : 0
                    }

                }
            }
        }
    }

    Timer {
        id: closeDelay

        interval: 3000
        running: false
        onTriggered: {
            root.close();
        }
    }
}

