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

import "../../../Core/App.js" as App

PopupBase {
    id: root

    width: 740
    title: qsTr("PUBLIC_TEST_TITLE")
    clip: true

    Text {
        anchors {
            left: parent.left
            right: parent.right
        }

        wrapMode: Text.WordWrap
        text: qsTr("PUBLIC_TEST_TEXT")
        font {
            family: 'Arial'
            pixelSize: 15
        }
        color: defaultTextColor
    }

    Row {
        spacing: 10

        PrimaryButton {
            text: qsTr("BUTTON_NOTIFY_SUPPORT")
            analytics {
                category: 'PublicTest'
                action: 'outer link'
                label: 'Support'
            }
            onClicked: App.openExternalUrl("https://support.gamenet.ru/kb");
        }

        MinorButton {
            text: qsTr("BUTTON_STOP_TESTING")
            analytics {
                category: 'PublicTest'
                label: 'Switch version'
            }
            onClicked: App.switchClientVersion();
        }

        MinorButton {
            text: qsTr("BUTTON_CLOSE")
            analytics {
                category: 'PublicTest'
                label: 'Close'
            }
            onClicked: root.close();
        }
    }
}
