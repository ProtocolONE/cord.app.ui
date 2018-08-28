import QtQuick 2.4
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0

WidgetModel {
    id: root

    property variant mainWindowInstance: App.mainWindowInstance()

    Connections {
        target: root.mainWindowInstance || null
        ignoreUnknownSignals: true

        onShowWebLicense: {
            var gameItem = App.serviceItemByServiceId(serviceId);
            if (!gameItem) {
                console.log('Error, the game does not exist');
                return;
            }

            if (gameItem.gameType !== "browser") {
                console.log('Error, it is not a browser game');
                return;
            }

            App.activateGame(gameItem);
            Popup.show('GameWebInstall');
        }
    }
}
