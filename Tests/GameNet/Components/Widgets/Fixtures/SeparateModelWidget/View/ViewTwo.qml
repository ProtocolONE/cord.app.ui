import QtQuick 2.4
import GameNet.Components.Widgets 1.0

WidgetView {
    width: 100
    height: 100

    Rectangle {
        anchors.fill: parent
        color: "purple"

        Text {
            anchors.centerIn: parent
            text: model.counter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: model.counter -= 10
        }
    }
}
