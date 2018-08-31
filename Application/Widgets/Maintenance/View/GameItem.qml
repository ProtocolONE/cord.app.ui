import QtQuick 2.4
import ProtocolOne.Core 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Image {
    id: root

    property variant currentGameItem
    property variant maintenanceGameItem

    width: 195
    height: 90

    source: maintenanceGameItem ? maintenanceGameItem.imageHorizontalSmall : ''

    Item {
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        height: 30

        ContentBackground {}

        Text {
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 7
            }

            text: root.maintenanceGameItem ? root.maintenanceGameItem.name : ""
            color: Styles.menuText
            font { family: 'Arial'; pixelSize: 14 }
        }
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            var currentGame = root.currentGameItem;
            var proposalGameItem = root.maintenanceGameItem;

            if (!currentGame) {
                return;
            }

            if (!proposalGameItem) {
                return;
            }

            App.activateGameByServiceId(proposalGameItem.serviceId);
            SignalBus.navigate('mygame', '');

            if (proposalGameItem.gameType === "browser") {
                App.downloadButtonStart(proposalGameItem.serviceId);
            }

            Ga.trackEvent('Maintenance', 'play', proposalGameItem.gaName);
        }
    }
}
