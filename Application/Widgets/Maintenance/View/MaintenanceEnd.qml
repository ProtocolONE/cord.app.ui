import QtQuick 2.4
import ProtocolOne.Core 1.0

import Application.Blocks 1.0
import Application.Core 1.0

GamePopup {
    id: popUp

    function gaEvent(name) {
        Ga.trackEvent('Announcement GgameMaintenanceEndShow', name, gameItem.gaName);
    }

    Connections {
        target: mainWindow
        onServiceStarted: {
            if (gameItem.serviceId == service) {
                shadowDestroy();
            }
        }
    }

    onAnywhereClicked: gaEvent('miss click')
    onTimeoutClosed: gaEvent('timeout close')
    onCloseButtonClicked: gaEvent('close')
    onPlayClicked: {
        gaEvent('play');
        App.activateWindow();
        App.activateGame(gameItem);
        App.executeService(gameItem.serviceId);
    }
}
