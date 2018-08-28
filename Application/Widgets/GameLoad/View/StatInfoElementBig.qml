import QtQuick 2.4
import Application.Controls 1.0
import Application.Core.Styles 1.0

Item {
    property alias infoText: infoTextElement.text
    property alias detailedText: detailedTextElement.text

    ContentThinBorder {
        anchors {
            fill: parent
            bottomMargin: 0
            rightMargin: 0
        }
    }

    Text {
        id: infoTextElement

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 9
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: Styles.popupText
    }

    Text {
        id: detailedTextElement

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 8
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: Styles.lightText
    }
}
