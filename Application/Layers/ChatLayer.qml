import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs

Item {

    anchors.fill: parent

    Rectangle {
        color: "#000000"
        opacity: 0.7
        height: 558
        visible: MessengerJs.userSelected()

        anchors {
            right: parent.right
            rightMargin: 230
            left: parent.left
            bottom: parent.bottom
        }

        CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursor: CursorArea.ArrowCursor
            onClicked: MessengerJs.closeChat()

        }
    }

    WidgetContainer {
        anchors {
            right: parent.right
            rightMargin: 230
            bottom: parent.bottom
        }

        height: 558
        width: 590
        widget: 'Messenger'
        view: 'Chat'
    }
}
