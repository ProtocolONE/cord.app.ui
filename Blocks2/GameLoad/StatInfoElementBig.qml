import QtQuick 1.1

Rectangle {

    property alias infoText: infoTextElement.text
    property alias detailedText: detailedTextElement.text

    border { color: '#dee2e5' }
    color: '#00000000'

    Text {
        id: infoTextElement

        anchors {
            centerIn: parent
            verticalCenterOffset: -9
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: '#606e7b'
    }

    Text {
        id: detailedTextElement

        anchors {
            centerIn: parent
            verticalCenterOffset: 9
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: '#fa6956'
    }
}
