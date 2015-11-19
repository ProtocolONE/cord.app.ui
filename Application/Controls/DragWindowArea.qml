import QtQuick 2.4
import Application.Core.RootWindow 1.0

MouseArea {
    id: root

    property variant rootWindow

    property point clickPos

    function moveTo(deltaX, deltaY) {
        if (!root.rootWindow) {
            return;
        }

        root.rootWindow.x = root.rootWindow.x + deltaX;
        root.rootWindow.y = root.rootWindow.y + deltaY;
    }

    onPressed: {
        clickPos = Qt.point(mouse.x,mouse.y)
    }

    onPositionChanged: {
        if (root.pressed && root.pressedButtons == Qt.LeftButton) {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            root.moveTo(delta.x, delta.y);
        }
    }
}
