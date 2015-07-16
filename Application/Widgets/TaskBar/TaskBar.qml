import QtQuick 2.4
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
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
        target: SignalBus

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
