import QtQuick 2.4
import GameNet.Controls 1.0

Rectangle {
    width: 1000
    height: 800
    color: "#00ff00"

    Component {
        id: source1

        Sample1 {
            color: "cyan"
        }
    }

    Component {
        id: source2

        Sample2 {
            color: "brown"
        }
    }

    PageSwitcher {
        id: switcher

        anchors.fill: parent
    }

    Row {
        anchors.fill: parent
        spacing: 10

        Button {
            width: 150
            height: 20
            text: "First Source"
            onClicked: switcher.source = "../../Tests/GameNet/Controls/PageSwitcher/Sample1.qml"
        }

        Button {
            width: 150
            height: 20
            text: "Second Source"
            onClicked: switcher.source = "../../Tests/GameNet/Controls/PageSwitcher/Sample2.qml"
        }

        Button {
            width: 150
            height: 20
            text: "First Component"
            onClicked: switcher.sourceComponent = source1
        }

        Button {
            width: 150
            height: 20
            text: "Second Component"
            onClicked: switcher.sourceComponent = source2
        }

        Button {
            width: 150
            height: 20
            text: "Switch 1-2 many"
            onClicked:  {

                d.queue = ["../../Tests/GameNet/Controls/PageSwitcher/Sample1.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample2.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample1.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample2.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample1.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample2.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample1.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample2.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample1.qml",
                "../../Tests/GameNet/Controls/PageSwitcher/Sample2.qml"
                        ];

                pusher.start();
            }
        }
    }

    QtObject {
        id: d

        property variant queue: [];
        property int index: 0

        function push() {
            switcher.source = queue[d.index];
            d.index += 1;

            if (d.index >= queue.length) {
                pusher.stop();
                d.index = 0;
            }
        }
    }

    Timer {
        id: pusher

        interval: 10
        repeat: true
        running: false
        onTriggered: {
            d.push();
        }
    }
}
