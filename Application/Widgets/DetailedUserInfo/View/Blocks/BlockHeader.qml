import QtQuick 2.4
import Application.Core 1.0
import Application.Core.Styles 1.0

Rectangle {
    property alias text: captionText.text

    implicitWidth: parent.width
    implicitHeight: 35
    color: Styles.applicationBackground

    Text {
        id: captionText

        anchors {
            left: parent.left
            leftMargin: 15
            verticalCenter: parent.verticalCenter
        }

        color: Styles.lightText
        textFormat: Text.RichText
    }
}

