import QtQuick 2.4

import GameNet.Controls 1.0

import Application.Core.Styles 1.0

Item {
    id: root

    property int cursorPosition: scroll.currentIndex
    property alias grid: gridView

    function positionViewAtIndex(pos) {
        scroll.positionViewAtIndex(pos, GridView.Beginning);
    }

    GridView {
        id: gridView

        anchors {
            fill: parent
            margins: 6
        }

        clip: true
        cellHeight: 30
        cellWidth: 30
        boundsBehavior: Flickable.StopAtBounds
    }

    ListViewScrollBar {
        id: scroll

        anchors {
            right: root.right
            rightMargin: 3
        }
        height: root.height
        width: 6
        listView: gridView
        cursorMaxHeight: root.height
        cursorMinHeight: 50
        color: "#00000000"
        cursorColor: Styles.contentBackgroundLight
        cursorOpacity: 0.1
    }
}
