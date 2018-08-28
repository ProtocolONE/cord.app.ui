import QtQuick 2.4

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0

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
            onClicked: App.openSupportUrl("/kb");
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
