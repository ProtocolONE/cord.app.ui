import QtQuick 2.4

import ProtocolOne.Controls 1.0

import Application.Blocks 1.0
import Application.Blocks.Popup 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

PopupBase {
    id: root

    property variant gameItem

    title: qsTr("UNINSTALL_TITLE").arg(root.gameItem ? root.gameItem.name : "");
    clip: true

    Component.onCompleted: {
        root.gameItem = App.currentGame();
    }

    Connections {
        target: SignalBus

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

    Text {
        font {
            family: "Arial"
            pixelSize: 15
        }
        smooth: true
        color: defaultTextColor
        text: d.getStatusText();
    }

    Item {
        width: parent.width
        height: 22

        Rectangle {
            id: progressBarBackgrount

            anchors.fill: parent
            color: "#00000000"
            opacity: Styles.blockInnerOpacity
            border { color: Styles.light }
        }

        DownloadProgressBar {
            anchors {
                fill: parent
                margins: 6
            }
            progress: root.gameItem ? root.gameItem.progress : 0
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

