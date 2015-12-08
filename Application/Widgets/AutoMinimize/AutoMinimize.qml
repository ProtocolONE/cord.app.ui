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

    Connections {
        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

        onServiceStarted: {
            if (App.isWindowVisible() && rootSettings.minimizeOnStart) {
                App.hide();
            }
        }

        onServiceFinished: {
            if (!App.isWindowVisible() && rootSettings.minimizeOnStart) {
                App.activateWindow();
            }
        }
    }
}
