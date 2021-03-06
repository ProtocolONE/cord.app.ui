import QtQuick 2.4
import Tulip 1.0

import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import Application.Core 1.0

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
        color: defaultTextColor
    }

    Row {
        id: internalContainer

        spacing: 10

        PrimaryButton {
            text: qsTr("BUTTON_RETRY_PLAY")
            analytics {
                category: "GameDownloadError"
                label: "Retry"
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
                category: "GameDownloadError"
                label: "Restart"
            }
            onClicked: {
                App.restartApplication();
                root.close();
            }
        }

        MinorButton {
            text: qsTr("BUTTON_NOTIFY_SUPPORT")
            analytics {
                category: "GameDownloadError"
                action: 'outer link'
                label: "Support"
            }

            onClicked: {
                root.close();
                App.openSupportUrl("/kb/articles/783-view");
            }
        }
    }
}
