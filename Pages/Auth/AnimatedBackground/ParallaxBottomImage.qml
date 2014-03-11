import QtQuick 1.1
import "../../../Controls"

ParallaxLayer {
    property alias source: image.source

    Image {
        id: image

        anchors {
            bottom:  parent.bottom
            bottomMargin: -parent.limitY * parent.depthY
            horizontalCenter: parent.horizontalCenter
        }
    }
}
