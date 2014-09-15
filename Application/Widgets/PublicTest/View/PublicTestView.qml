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

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import GameNet.Controls 1.0

import "../../../Core/App.js" as App
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

PopupBase {
    id: root

    width: 670
    title:  qsTr("PUBLIC_TEST_TITLE")
    clip: true

    Text {
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }
        wrapMode: Text.WordWrap
        text: qsTr("PUBLIC_TEST_TEXT")
        font {
            family: 'Arial'
            pixelSize: 15
        }
        color: defaultTextColor
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
            id: notifySupportButton

            width: 190
            height: 48
            text: qsTr("BUTTON_NOTIFY_SUPPORT")
            analytics: GoogleAnalyticsEvent {
                page: '/PublicTest'
                category: 'Public Test'
                action: 'support'
            }

            onClicked: App.openExternalUrl("https://support.gamenet.ru/kb");
        }

        Button {
            id: stopTestingButton

            width: 300
            height: 48
            text: qsTr("BUTTON_STOP_TESTING")
            analytics: GoogleAnalyticsEvent {
                page: '/PublicTest'
                category: 'Public Test'
                action: 'switch version'
            }

            onClicked: App.switchClientVersion();
        }

        Button {
            id: closeButton

            width: 100
            height: 48
            text: qsTr("BUTTON_CLOSE")
            analytics: GoogleAnalyticsEvent {
                page: '/PublicTest'
                category: 'Public Test'
                action: 'close'
            }

            onClicked: root.close();
        }
    }
}
