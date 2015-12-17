import QtQuick 2.4
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    settings: WidgetSettings {
        id: rootSettings

        namespace: 'AutoMinimaze'
        property bool minimizeOnStart: true
    }

    function isBrowserGame(service) {
        var item = App.serviceItemByServiceId(service);
        if (!item || item.gameType == "browser") {
            return true;
        }
        return false;
    }

    Connections {
        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

        onServiceStarted: {
            if (isBrowserGame(service)) {
                return;
            }

            if (App.isWindowVisible() && rootSettings.minimizeOnStart) {
                App.hide();
            }
        }

        onServiceFinished: {
            if (isBrowserGame(service)) {
                return;
            }

            if (!App.isWindowVisible() && rootSettings.minimizeOnStart) {
                App.activateWindow();
            }
        }
    }
}
