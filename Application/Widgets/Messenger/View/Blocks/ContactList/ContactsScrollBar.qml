import QtQuick 2.4
import GameNet.Controls 1.0
import Application.Core.Styles 1.0
import "../../../Models/Messenger.js" as Messenger

ListViewScrollBar {
    id: scrollBar

    width: 6
    height: scrollBar.listView.height
    cursorMaxHeight: scrollBar.listView.height
    cursorMinHeight: 50
    cursorRadius: 4
    color: "#00000000"
    cursorColor: Styles.contentBackgroundLight
    cursorOpacity: 0.1
    onMovingChanged: Messenger.setHeavyInteraction(moving)
}
