import QtQuick 1.1
import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App
import "TaskBar.js" as TaskBar

WidgetModel {
    id: root

    property bool messengerActive: false
    property bool highlightYellow: !Qt.application.active && messengerActive

    onHighlightYellowChanged: {
        if (highlightYellow) {
            App.updateProgressEx(100, "Paused");
        } else {
            App.updateProgressEx(TaskBar.getOverallProgress(), TaskBar.getOverallStatus());
        }
    }

    Connections {
        target: App.signalBus()

        onProgressChanged: {
            TaskBar.updateProgress(gameItem);
            App.updateProgressEx(TaskBar.getOverallProgress(), TaskBar.getOverallStatus());
        }

        onUnreadContactsChanged: {
            if (contacts == 0) {
                root.messengerActive = false;
                return;
            }

            root.messengerActive = true;
        }

        onUpdateTaskbarIcon: {
            var iconPath = installPath + source;
            iconPath = iconPath.replace('file:///', '');

            App.setTaskbarIcon(iconPath);
        }
    }
}
