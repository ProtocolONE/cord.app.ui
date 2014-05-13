import QtQuick 1.1
import Tulip 1.0

import "../Pages" as Pages
import "../Blocks2" as Blocks2

Rectangle {
    id: sampleRoot

    color: "black"
    width: 1000
    height: 600

    Pages.GameSettings {
        id: gameSettings

        width: parent.width
        height: 558
        anchors {
            bottom: parent.bottom
        }
    }
}
