import QtQuick 1.1

Item {
    default property alias data: column.data

    function scrollToBegin() {
        flickable.contentY = 0;
    }

    Item {
        anchors { fill: parent }
        clip: true

        Flickable {
            id: flickable

            anchors { fill: parent }
            contentWidth: width
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: column

                width: parent.width

                onHeightChanged: flickable.contentHeight = height;
            }
        }
    }

    ScrollBar {
        flickable: flickable
        anchors {
            right: parent.right
            rightMargin: 2
        }
        height: parent.height
        scrollbarWidth: 5
    }
}
