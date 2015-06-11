import QtQuick 1.1
import GameNet.Controls 1.0 as Controls
import Application.Controls 1.0

import "../../../Core/Styles.js" as Styles

Image {
    id: root

    signal activate()
    property variant gameItem

    width: 195
    height: 90

    source: !!gameItem && gameItem.imageHorizontalSmall ? gameItem.imageHorizontalSmall : ''

    Item {
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        height: 30

        ContentBackground {}

        Text {
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 7
            }

            text: root.gameItem ? root.gameItem.name : ""
            color: Styles.style.menuText
            font { family: 'Arial'; pixelSize: 14 }
        }
    }

    Controls.CursorMouseArea {
        anchors.fill: parent
        onClicked: root.activate();
    }
}
