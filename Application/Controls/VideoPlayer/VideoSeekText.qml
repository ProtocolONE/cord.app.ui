import QtQuick 2.4

Text {
    id: seekText
    color: "#FFFFFF"

    Rectangle {
        anchors.centerIn: parent
        radius: 2
        width: parent.paintedWidth + 10
        height: parent.paintedHeight + 5
        color: "#000000"
        opacity: 0.7
    }
}

