import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

WidgetView {
    width: 100
    height: 100
    clip: true

    Rectangle {
        anchors.fill: parent
        color: "blue"

        Timer {
            repeat: true
            running: true
            interval: 1000
            onTriggered: text.text = Math.random()
        }

        Text {
            id: text
            anchors.centerIn: parent
        }
    }
}
