import QtQuick 1.1
import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App
import "TaskBar.js" as TaskBar

WidgetModel {
    id: root

    Connections {
        target: App.signalBus()

        onProgressChanged: {
            TaskBar.updateProgress(gameItem);
            App.updateProgressEx(TaskBar.getOverallProgress(), TaskBar.getOverallStatus());
        }
    }
}
