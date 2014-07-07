import QtQuick 1.1

Image {
    property alias background: back.color;

    onSourceChanged: back.opacity = 1
    onStatusChanged: {
        if (status === Image.Ready) {
            back.opacity = 0;
        }
    }

    Rectangle {
        id: back

        anchors.fill: parent
        color: "#000000"
        opacity: 1
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
            playing: parent.visible
        }
    }
}
