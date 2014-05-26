import QtQuick 1.1
import GameNet.Controls 1.0 as Controls

Image {
    id: root

    signal activate()
    property variant gameItem

    width: 195
    height: 90

    source: installPath + gameItem.imageHorizontalSmall

    Rectangle {
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        height: 30
        color: '#082135'
        opacity: 0.8
    }

    Text {
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 7
        }

        text: gameItem.name
        color: '#ffffff'
        font { family: 'Arial'; pixelSize: 14 }
    }

    Controls.CursorMouseArea {
        anchors.fill: parent
        onClicked: root.activate();
    }
}
