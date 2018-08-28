import QtQuick 2.4

Item {
    property SplitterStyleColors style: SplitterStyleColors {}

    implicitWidth: 2
    implicitHeight: 100

    Rectangle {
        width: 1
        height: parent.height
        color: style.main
    }

    Rectangle {
        x: 1
        width: 1
        height: parent.height
        color: style.shadow
    }
}
