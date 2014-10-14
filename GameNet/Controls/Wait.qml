import QtQuick 1.1

Item {
    id: root

    property bool running: true

    implicitWidth: img.width
    implicitHeight: img.height

    QtObject {
        id: d

        property int frameCounter: 0
        property string path: "Assets/Images/GameNet/Controls/Wait/728_alpha20_" + pad(frameCounter + 1, 2) + ".png";

        function pad(num, size) {
            var s = num + "";
            while (s.length < size) s = "0" + s;
            return s;
        }
    }

    Timer {
        running: root.running
        repeat: true
        interval: 40
        onTriggered: {
            d.frameCounter = (d.frameCounter + 1) % 29;
        }
    }

    Image {
        id: img

        width: 32
        height: 34
        source: installPath + d.path
    }
}
