import QtQuick 1.1
import "../../../../../Core/Styles.js" as Styles

Item { // background
    anchors.fill: parent

    Rectangle {
        color: "#00000000"
        border {
            width: 1
            color: Styles.style.messengerGroupEditBorder
        }

        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
            topMargin: 12
        }
    }

    Rectangle { // arrow point
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 29
            topMargin: 0
        }

        rotation: 45
        transformOrigin: Item.TopLeft

        color: Styles.style.messengerGroupEditBorder
        width: 19
        height: 19

        Rectangle {
            color: Styles.style.messengerGroupEditBackground
            width: 16
            height: 16
            x: 1
            y: 1
        }
    }

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
            leftMargin: 1
            topMargin: 13
        }

        color: Styles.style.messengerGroupEditBackground
    }
}
