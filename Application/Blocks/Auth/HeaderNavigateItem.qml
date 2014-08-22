import QtQuick 1.1

Row {
    id: root

    property alias num: numElement.text
    property alias text: textElement.text
    property alias color: rect.color
    property color textColor
    property color borderColor
    property alias transparency: rect.opacity

    spacing: 10

    Rectangle {
        id: rect

        width: 35
        height: width
        radius: width / 2
        border { width: 2; color: root.borderColor }

        Text {
            id: numElement

            anchors.centerIn: parent

            font {
                family: 'Arial'
                pixelSize: 24
            }
            color: root.borderColor
        }
    }

    Text {
        id: textElement

        y: 7

        height: parent.height
        font {
            family: 'Arial'
            pixelSize: 18
        }
        color: root.textColor
    }
}
