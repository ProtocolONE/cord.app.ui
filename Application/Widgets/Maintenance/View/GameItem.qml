import QtQuick 1.1
import GameNet.Controls 1.0 as Controls
import Application.Controls 1.0

import "../../../../GameNet/Core/Analytics.js" as Ga

import "../../../Core/Styles.js" as Styles
import "../../../Core/App.js" as App

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
            color: Styles.style.menuText
            font { family: 'Arial'; pixelSize: 14 }
        }
    }

    Controls.CursorMouseArea {
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
            App.navigate('mygame');

            if (proposalGameItem.gameType === "browser") {
                App.downloadButtonStart(proposalGameItem.serviceId);
            }

            Ga.trackEvent('Maintenance', 'play', proposalGameItem.gaName);
        }
    }
}
