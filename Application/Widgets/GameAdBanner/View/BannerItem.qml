import QtQuick 1.1

Item {
    id: root

    function setContent(imageSource, label) {
        contentImage.source = imageSource;
       contentText.text = label;
    }

    Image {
        id: contentImage

        anchors.fill: parent
    }

    Item {
        width: parent.width
        height: textBackground.height
        anchors.bottom: parent.bottom

        Rectangle {
            id: textBackground

            width: contentText.width
            height: contentText.lineCount > 1 ? 60: 40
            opacity: 0.3
            color: "#092135"
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
            color: "#fafafa"
            font { family: "Arial"; pixelSize: 20 }
            lineHeightMode: Text.FixedHeight
            lineHeight: 22
        }
    }
}
