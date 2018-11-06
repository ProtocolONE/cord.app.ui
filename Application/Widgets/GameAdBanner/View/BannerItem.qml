import QtQuick 2.4
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property alias source: contentImage.source
    property alias text: contentText.text
    property string bannerId

    WebImage {
        id: contentImage

        anchors.fill: parent
    }

    Item {
        width: parent.width
        height: textBackground.height
        anchors.bottom: parent.bottom
        visible: contentText.text

        Rectangle {
            id: textBackground

            width: contentText.width
            height: contentText.lineCount > 1 ? 60: 40
            color: Styles.contentBackground
            opacity: Styles.baseBackgroundOpacity
        }

        Text {
            id: contentText

            width: parent.width
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            wrapMode: Text.WordWrap
            opacity: 0.8
            color: Styles.textBase
            font { family: "Arial"; pixelSize: 20 }
            lineHeightMode: Text.FixedHeight
            lineHeight: 22
        }
    }
}
