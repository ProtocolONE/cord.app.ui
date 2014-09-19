import QtQuick 1.1
import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App

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
