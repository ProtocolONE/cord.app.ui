import QtQuick 2.4

Item {
    property variant style: SplitterStyleColors {}

    implicitWidth: 100
    implicitHeight: 2

    Rectangle {
        height: 1
        width: parent.width
        color: style.main
    }

    Rectangle {
        y: 1
        height: 1
        width: parent.width
        color: style.shadow
    }
}
