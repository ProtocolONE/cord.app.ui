import QtQuick 1.1
import Application.Controls 1.0
import "../../../../../Core/Styles.js" as Styles

Item { // background
    anchors.fill: parent

    Rectangle {
        anchors {
            fill: parent
            topMargin: 12
        }

        color: Styles.style.popupBlockBackground
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
        color: Styles.style.popupBlockBackground
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
