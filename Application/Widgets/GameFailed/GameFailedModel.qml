import QtQuick 2.4
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    property string lastStoppedServiceId

    Connections {
        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

        onServiceFinished: {
            root.lastStoppedServiceId = service;
        }
    }
}
