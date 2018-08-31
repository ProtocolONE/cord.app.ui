import QtQuick 2.4

Rectangle {
    Component.onDestruction: console.log('---- Source 1 destroyed')
    color: "yellow";

    Text {
        anchors.centerIn: parent
        text: "Sample1"
        color: "#000000"
        font.pixelSize: 26
    }

}
