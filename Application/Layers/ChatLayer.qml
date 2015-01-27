import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs
import "../Core/Styles.js" as Styles

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Styles.style.messengerSmilePanelHover
        opacity: 0.78

        visible: MessengerJs.smilePanelVisible()

        CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursor: CursorArea.ArrowCursor
            onClicked: MessengerJs.setSmilePanelVisible(false)
        }
    }

    Rectangle {
        color: "#000000"
        opacity: 0.7
        height: 560
        visible: MessengerJs.userSelected() && !MessengerJs.smilePanelVisible()

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

        height: 560
        width: 590
        widget: 'Messenger'
        view: 'Chat'
    }
}
