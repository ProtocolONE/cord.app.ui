import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    property int mouseX: 0
    property int mouseY: 0

    property bool invertX: true
    property bool invertY: true

    property real limitX: root.width / 2
    property real limitY: root.height / 2

    property real frictionX: 0.05
    property real frictionY: 0.1

    property int refreshTimeout: 33

    signal beforeUpdate();

    implicitWidth: 100
    implicitHeight: 100

    onWidthChanged: d.calibrateRequest();
    onHeightChanged: d.calibrateRequest();

    QtObject {
        id: d

        property bool calibrate: true

        property int centerX: root.width / 2
        property int centerY: root.height / 2

        property real vx
        property real vy

        function clamp(value, min, max) {
            value = Math.max(value, min);
            value = Math.min(value, max);
            return value;
        }

        function calibrateRequest() {
            d.calibrate = true;
        }

        function mousePosition() {
            return {
                x: root.mouseX,
                y: root.mouseY
            };
        }

        function update() {
            var mouse = d.mousePosition();
            var dx = (mouse.x - d.centerX) * (root.invertX ? -1 : 1);
            var dy = (mouse.y - d.centerY) * (root.invertY ? -1 : 1);

            dx = d.clamp(dx, -root.limitX, root.limitX);
            dy = d.clamp(dy, -root.limitY, root.limitY);

            d.vx += (dx - d.vx) * root.frictionX;
            d.vy += (dy - d.vy) * root.frictionY;

            for (var i = 0; i < root.children.length; ++i) {
                var child = root.children[i]
                if (d.calibrate) {
                    child.width = root.width;
                    child.height = root.height;

                    child.limitX = root.limitX;
                    child.limitY = root.limitY;
                }

                child.x = d.vx * child.depthX;
                child.y = d.vy * child.depthY;
            }

            d.calibrate = false;
        }
    }

    Timer {
        id: drawTimer

        interval: root.refreshTimeout
        running: true
        repeat: true
        onTriggered: {
            beforeUpdate();
            d.update();
        }
    }
}
