/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property variant gameItem

    Component.onCompleted: {
        root.gameItem = App.currentGame();
    }

    width: 850
    height: allContent.height + 40
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "#F0F5F8"
    }

    Column {
        id: allContent

        y: 20
        spacing: 20

        Text {
            anchors {
                left: parent.left
                leftMargin: 20
            }
            font {
                family: 'Arial'
                pixelSize: 20
            }
            color: '#343537'
            smooth: true
            text: qsTr("GAME_DOWNLOAD_ERROR_TITLE")
        }

        HorizontalSplit {
            width: root.width

            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Text {
            anchors {
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
            }
            wrapMode: Text.WordWrap
            text: qsTr("GAME_DOWNLOAD_ERROR_TEXT")
            font {
                family: 'Arial'
                pixelSize: 15
            }
            color: '#5c6d7d'
        }

        HorizontalSplit {
            width: root.width
            style: SplitterStyleColors {
                main: "#ECECEC"
                shadow: "#FFFFFF"
            }
        }

        Row {
            spacing: 20
            anchors {
                left: parent.left
                leftMargin: 20
            }

            Button {
                id: playRetryButton

                width: 290
                height: 48
                text: qsTr("BUTTON_RETRY_PLAY")
                onClicked: {
                    if (root.gameItem) {
                        App.downloadButtonStart(root.gameItem.serviceId);
                    }

                    root.close();
                }
            }

            Button {
                id: restartApplicatonButton

                width: 220
                height: 48
                text: qsTr("BUTTON_RESTART_APPLICATION")
                onClicked: {
                    App.restartApplication();
                    root.close();
                }
            }

            Button {
                id: openSupportButton

                width: 260
                height: 48

                text: qsTr("BUTTON_NOTIFY_SUPPORT")
                onClicked: {
                    root.close();
                    App.openExternalUrl("http://support.gamenet.ru");
                }
            }
        }
    }
}
