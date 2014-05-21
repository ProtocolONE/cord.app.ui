import QtQuick 1.1

import "../../../js/Core.js" as Core
import "../../Core/App.js" as App
import "TaskBar.js" as TaskBarJs

Item {
    id: root

    Connections {
        target: Core.signalBus()

        onProgressChanged: {
            TaskBarJs.updateProgress(gameItem);
            App.updateProgress(TaskBarJs.getOverallProgress(), TaskBarJs.getOverallStatus());
        }
    }
}
