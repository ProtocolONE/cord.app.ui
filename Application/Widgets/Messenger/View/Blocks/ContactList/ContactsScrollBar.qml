import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger

ListViewScrollBar {
    id: scrollBar

    width: 7
    height: scrollBar.listView.height
    cursorMaxHeight: scrollBar.listView.height
    cursorMinHeight: 50
    cursorRadius: 4
    color: "#00000000"
    cursorColor: Styles.style.contactScrollBar
    opacity: 0.5

    onMovingChanged: Messenger.setHeavyInteraction(moving)
}
