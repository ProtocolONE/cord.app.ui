import QtQuick 1.1

import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../../Core/Styles.js" as Styles
import "../../ContactList"
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
            margins: 3
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
        }
        height: root.height
        width: 6
        listView: gridView
        cursorMaxHeight: root.height
        cursorMinHeight: 50
        color: "#00000000"
        cursorColor: Styles.style.contentBackgroundLight
        cursorOpacity: 0.1
    }

 // UNDONE чуйка есть что нужно положить 1 бордер вокруг всего контрола а не так дрочиться
    ContentStroke {
        height: parent.height
    }
}
