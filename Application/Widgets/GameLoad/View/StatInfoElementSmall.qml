import QtQuick 2.4
import Application.Controls 1.0
import Application.Core.Styles 1.0

Item  {
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
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
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
            right: parent.right
            rightMargin: 12
            verticalCenter: parent.verticalCenter
        }

        font {
            family: "Arial"
            pixelSize: 12
        }

        color: Styles.lightText
    }
}
