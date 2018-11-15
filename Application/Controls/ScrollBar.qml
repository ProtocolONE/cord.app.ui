import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Tulip 1.0

Item {
    id: scrollBarElement

    property int scrollbarWidth: 16
    property variant flickable
    property bool allwaysShown: false

    clip: true

    implicitWidth: scrollbarWidth
    implicitHeight: parent.height

    x: parent.width - width
    y: 0

    MouseArea {
        id: scrollMouser

        anchors.fill: parent
        visible: flickable.contentHeight > height

        acceptedButtons: Qt.LeftButton
        hoverEnabled: true

        drag.axis: Drag.YAxis
        drag.minimumX: 0
        drag.maximumX: scrollBarElement.width - thumb.width
        drag.minimumY: 0
        drag.maximumY: scrollBarElement.height - thumb.height

        function move() {
            var step = flickable.contentHeight / scrollBarElement.height * thumb.height

            if (scrollMouser.mouseY < thumb.y) {
                flickable.contentY = Math.max(0, flickable.contentY - step)
            } else if(scrollMouser.mouseY > (thumb.y + thumb.height)) {
                flickable.contentY =
                        Math.min(flickable.contentHeight - scrollBarElement.height, flickable.contentY + step)
            }
        }

        onPositionChanged: {
            if (mouse.buttons == Qt.LeftButton) {
                flickable.contentY = flickable.contentHeight / height * thumb.y
            }
        }

        onPressed: {
            if (mouseY >= thumb.y && mouseY <= (thumb.y + thumb.height)) {
                drag.target = thumb;
            } else {
                drag.target = null
                moveTick.start();
            }
        }

        onReleased: moveTick.stop();

        Timer {
            id: moveTick
            interval: 150
            repeat: true
            triggeredOnStart: true
            onTriggered: scrollMouser.move()
        }

        Item {
            id: thumb

            function containsMouse() {
                return (scrollMouser.containsMouse || scrollMouser.drag.active || flickable.moving);
            }

            width: scrollbarWidth
            height: flickable.visibleArea.heightRatio * parent.height

            x: parent.width - width
            y: flickable.visibleArea.yPosition * parent.height

            opacity: scrollBarElement.allwaysShown ? 1 : thumb.containsMouse() ? 1 : 0 //.25

            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on width { NumberAnimation { duration: 150 } }

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#A3A3A3"
                radius: width/2
            }

            MouseArea {
               anchors.fill: parent
               acceptedButtons: Qt.NoButton
               cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
