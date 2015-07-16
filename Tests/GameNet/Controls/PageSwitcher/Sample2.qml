import QtQuick 2.4

Rectangle {
    Component.onDestruction: console.log('---- Source 2 destroyed')
    color: "blue";

    Text {
        anchors.centerIn: parent
        text: "Sample2"
        color: "#000000"
        font.pixelSize: 26
    }

}
