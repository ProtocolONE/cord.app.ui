import QtQuick 2.4
import Application.Controls 1.0
import Application.Core.Styles 1.0

Item { // background
    anchors.fill: parent

    Rectangle {
        anchors {
            fill: parent
            topMargin: 12
        }

        color: Styles.popupBlockBackground
    }

    ContentThinBorder {
        anchors.topMargin: 12
    }

    Rectangle { // arrow point
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 29-12
            topMargin: 0
        }

        rotation: 45
        transformOrigin: Item.TopLeft
        color: Styles.popupBlockBackground
        width: 19
        height: 19

        ContentStroke {
            width: parent.width - 1
        }

        ContentStroke {
            height: parent.height - 2
            y: 1
        }
    }
}
