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
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

PopupBase {
    id: root

    property variant gameItem

    Component.onCompleted: {
        root.gameItem = App.currentGame();
    }

    title: qsTr("GAME_DOWNLOAD_ERROR_TITLE")
    width: 850
    clip: true

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

    PopupHorizontalSplit {
        width: root.width
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

            analytics: GoogleAnalyticsEvent {
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

        Button {
            width: 220
            height: 48
            text: qsTr("BUTTON_RESTART_APPLICATION")

            analytics: GoogleAnalyticsEvent {
                page: "/game/" + gameItem.gaName
                category: "Game " + gameItem.gaName
                action: "Restart button clicked"
            }


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

            analytics: GoogleAnalyticsEvent {
                page: "/game/" + gameItem.gaName
                category: "Game " + gameItem.gaName
                action: "Support button clicked"
            }

            onClicked: {
                root.close();
                App.openExternalUrl("http://support.gamenet.ru");
            }
        }
    }

}
