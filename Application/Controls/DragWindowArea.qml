import QtQuick 2.4
import Application.Core.RootWindow 1.0

MouseArea {
    id: root

    property point clickPos

    onPressed: {
        clickPos = Qt.point(mouse.x,mouse.y)
    }

    onPositionChanged: {
        if (root.pressed && root.pressedButtons == Qt.LeftButton) {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            RootWindow.moveTo(delta.x, delta.y);
        }
    }
}
