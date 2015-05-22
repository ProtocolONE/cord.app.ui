import QtQuick 1.1

Item {
    implicitWidth: 44
    implicitHeight: 44

    Row {
        x: 7
        height: 7
        spacing: 5
        anchors {
            bottom: parent.bottom
        }

        Repeater {
            model: 3

            delegate: Rectangle {
                width: 4
                height: 4
                radius: 2
            }
        }
    }
}
