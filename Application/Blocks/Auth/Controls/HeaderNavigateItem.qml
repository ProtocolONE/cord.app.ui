import QtQuick 2.4

Row {
    id: root

    property bool disabled: false
    property alias num: numElement.text
    property alias text: textElement.text
    property color textColor
    property color borderColor
    property alias transparency: rect.opacity

    spacing: 10

    Item {
        width: 20
        height: 20

        Rectangle {
            id: rect

            color: "#00000000"
            width: parent.width
            height: parent.width
            radius: parent.width / 2
            border { width: 2; color: root.borderColor }
            opacity: root.disabled ? 0.5 : 1
        }

        Text {
            id: numElement

            anchors.centerIn: parent
            font {
                family: 'Open Sans Light'
                pixelSize: 14
            }
            color: root.textColor
        }
    }

    Text {
        id: textElement

        anchors.verticalCenter: parent.verticalCenter
        opacity: root.disabled ? 0.5 : 1
        height: parent.height
        font {
            family: 'Open Sans Light'
            pixelSize: 15
        }
        color: root.textColor
    }
}
