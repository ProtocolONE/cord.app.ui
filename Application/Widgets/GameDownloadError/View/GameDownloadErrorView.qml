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

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import "../../../Core/App.js" as App

PopupBase {
    id: root

    property variant gameItem

    Component.onCompleted: {
        root.gameItem = App.currentGame();
    }

    title: qsTr("GAME_DOWNLOAD_ERROR_TITLE")
    width: internalContainer.width + defaultMargins * 2
    clip: true

    Text {
        anchors {
            left: parent.left
            right: parent.right
        }
        wrapMode: Text.WordWrap
        text: qsTr("GAME_DOWNLOAD_ERROR_TEXT")
        font {
            family: 'Arial'
            pixelSize: 15
        }
        color: '#5c6d7d'
    }

    Row {
        id: internalContainer

        spacing: 10

        PrimaryButton {
            text: qsTr("BUTTON_RETRY_PLAY")
            analytics {
                page: "/GameDownloadError/"
                category: "Game " + gameItem.gaName
                action: "Retry button clicked"
            }

            onClicked: {
                if (root.gameItem) {
                    App.downloadButtonStart(root.gameItem.serviceId);
                }

                root.close();
            }
        }

        MinorButton {
            text: qsTr("BUTTON_RESTART_APPLICATION")
            analytics {
                page: "/game/" + gameItem.gaName
                category: "Game " + gameItem.gaName
                action: "Restart button clicked"
            }
            onClicked: {
                App.restartApplication();
                root.close();
            }
        }

        MinorButton {
            text: qsTr("BUTTON_NOTIFY_SUPPORT")
            analytics {
                page: "/game/" + gameItem.gaName
                category: "Game " + gameItem.gaName
                action: "Support button clicked"
            }

            onClicked: {
                root.close();
                App.openExternalUrl("https://support.gamenet.ru/kb");
            }
        }
    }
}
