import QtQuick 2.4
import Tulip 1.0

import Application.Blocks 1.0

Rectangle {
    id: sampleRoot

    color: "black"
    width: 1000
    height: 600

    GameSettings {
        id: gameSettings

        width: parent.width
        height: 558
        anchors {
            bottom: parent.bottom
        }
    }
}
