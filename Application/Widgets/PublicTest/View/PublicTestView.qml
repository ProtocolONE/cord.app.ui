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
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Core/App.js" as App
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetView {
    id: root

    width: 670
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
            text: qsTr("PUBLIC_TEST_TITLE")
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
            text: qsTr("PUBLIC_TEST_TEXT")
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
                id: notifySupportButton

                width: 190
                height: 48
                text: qsTr("BUTTON_NOTIFY_SUPPORT")
                analytics: GoogleAnalyticsEvent {
                    page: '/PublicTest'
                    category: 'Public Test'
                    action: 'support'
                }

                onClicked: App.openExternalUrl("http://support.gamenet.ru");
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
}
