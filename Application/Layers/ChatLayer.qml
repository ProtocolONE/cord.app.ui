import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs
import "../Core/Styles.js" as Styles
import "../Core/App.js" as App

Item {
    id: root

    anchors.fill: parent

    QtObject {
        id: d

        property bool isChatOpen: MessengerJs.userSelected()
        property bool isDetailedInfoOpened: userInfo.viewInstance.isOpened();
    }

    Rectangle {
        color: Styles.style.contentBackgroundDark
        opacity: Styles.style.darkBackgroundOpacity
        height: 560
        visible: d.isChatOpen && !d.isDetailedInfoOpened

        anchors {
            right: parent.right
            left: parent.left
            leftMargin: 230
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
            left: parent.left
            leftMargin: 230
            bottom: parent.bottom
        }

        height: 560
        width: 590
        widget: 'Messenger'
        view: 'Chat'
    }

    Rectangle {
        color: Styles.style.contentBackgroundDark
        opacity: Styles.style.darkBackgroundOpacity
        height: 560
        visible: d.isDetailedInfoOpened

        anchors {
            right: parent.right
            left: parent.left
            leftMargin: 230
            bottom: parent.bottom
        }

        CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursor: CursorArea.ArrowCursor
            onClicked: App.closeDetailedUserInfo();
        }
    }

    WidgetContainer {
        id: userInfo

        anchors {
            left: parent.left
            leftMargin: 230
            bottom: parent.bottom
        }

        height: 560
        width: 353
        widget: 'DetailedUserInfo'
        view: 'DetailedUserInfoView'
    }
}
