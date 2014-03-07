import QtQuick 1.1
import "../../../Controls"

ParallaxLayer {
    property alias source: image.source

    Image {
        id: image

        anchors.bottom:  parent.bottom
        anchors.bottomMargin: -parent.limitY * parent.depthY
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
