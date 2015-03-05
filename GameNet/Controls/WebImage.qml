import QtQuick 1.1

Image {
    property bool isReady: status == Image.Ready
    property alias background: back.color

    Rectangle {
        id: back

        anchors.fill: parent
        color: "#000000"
        opacity: parent.status == Image.Ready ? 0 : 1
        visible: opacity > 0

        Behavior on opacity {
            PropertyAnimation {
                duration: 250
            }
        }

        AnimatedImage {
            source: installPath + 'Assets/Images/GameNet/Controls/WebImage/loading.gif'
            anchors.centerIn: parent
            cache: true
            asynchronous: true
            playing: parent.visible
        }
    }
}
