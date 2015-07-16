import QtQuick 2.4
import Application.Controls 1.0

Rectangle {
    anchors.fill: parent
    opacity: 0.95

    ContentStroke {
        height: parent.height
        anchors.left: parent.left
        opacity: 0.15
    }

    ContentStroke {
        height: parent.height
        anchors.right: parent.right
        opacity: 0.15
    }

    ContentStroke {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 1
            rightMargin: 1
        }
        opacity: 0.15
    }
}
