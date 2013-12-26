import QtQuick 1.1

import "../../js/Core.js" as Core
import "../../Proxy/App.js" as App
import "TaskBarHelper.js" as Helper

Item {
    id: root

    Connections {
        target: Core.signalBus()

        onProgressChanged: {
            Helper.updateProgress(gameItem);
            App.updateProgress(Helper.getOverallProgress(), Helper.getOverallStatus());
        }
    }
}
