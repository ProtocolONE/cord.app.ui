import QtQuick 1.1

import "../../Core/App.js" as App
import "TaskBar.js" as TaskBar

Item {
    id: root

    Connections {
        target: App.signalBus()

        onProgressChanged: {
            TaskBar.updateProgress(gameItem);
            App.updateProgressEx(TaskBar.getOverallProgress(), TaskBar.getOverallStatus());
        }
    }
}
