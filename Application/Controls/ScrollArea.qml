import QtQuick 2.4

Item {
    default property alias data: column.data
    property alias allwaysShown: scrollBar.allwaysShown
    property alias scrollbarWidth: scrollBar.scrollbarWidth

    property alias yPosition: flickable.yPosition
    property alias heightRatio: flickable.heightRatio

    function scrollToBegin() {
        flickable.contentY = 0;
    }

    Item {
        anchors { fill: parent }
        clip: true

        Flickable {
            id: flickable

            property real yPosition : flickable.visibleArea.yPosition
            property real heightRatio : flickable.visibleArea.heightRatio

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
        id: scrollBar

        flickable: flickable
        anchors {
            right: parent.right
            rightMargin: 2
        }
        height: parent.height
        scrollbarWidth: 5
    }
}
