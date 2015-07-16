pragma Singleton

import QtQuick 2.4
import QtQuick.Window 2.2

import Application.Core 1.0

Item {
    id: root

    property variant rootWindow: App.mainWindowInstance()

    function moveTo(deltaX, deltaY) {
        if (!root.rootWindow) {
            return;
        }

        root.rootWindow.x = root.rootWindow.x + deltaX;
        root.rootWindow.y = root.rootWindow.y + deltaY;
    }
}
