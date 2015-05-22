import QtQuick 1.1

Item {
    id: root

    default property alias data: content.data
    property int borderSize: 1
    property color borderColor: "#00FFFFFF"

    //  left
    Rectangle {
        color: root.borderColor
        width: root.borderSize
        height: root.height
    }
    //  top
    Rectangle {
        color: root.borderColor
        width: root.width
        height: root.borderSize
    }
    //  right
    Rectangle {
        color: root.borderColor
        x: root.width - root.borderSize
        width: root.borderSize
        height: root.height
    }
    //  bottom
    Rectangle {
        color: root.borderColor
        y: root.height - root.borderSize
        width: root.width
        height: root.borderSize
    }

    Item {
        id: content

        anchors {
            fill: parent
            margins: root.borderSize
        }
    }
}
