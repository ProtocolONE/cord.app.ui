import QtQuick 1.1

import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../../Core/Styles.js" as Styles

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
        width: 7
        listView: gridView
        cursorMaxHeight: root.height
        cursorMinHeight: 50
        color: Styles.style.messangerChatDialogScrollBar
        cursorColor: Styles.style.messangerChatDialogScrollBarCursor
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: 1
        height: parent.height
        color: Styles.style.messengerSmilePanelBorder
    }
}
