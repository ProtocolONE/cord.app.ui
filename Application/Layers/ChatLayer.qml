import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs
import "../Core/Styles.js" as Styles
import "../Core/App.js" as App

Item {
    id: root

    anchors {
        fill: parent
        topMargin: 30
        leftMargin: 231
    }

    QtObject {
        id: d

        property bool isChatOpen: MessengerJs.userSelected()
        property bool isDetailedInfoOpened: userInfo.viewInstance.isOpened();
    }

    WidgetContainer {
        anchors.fill: parent
        widget: 'Messenger'
        view: 'Chat'
    }

    Rectangle {
        color: Styles.style.contentBackgroundDark
        opacity: Styles.style.darkBackgroundOpacity
        visible: d.isDetailedInfoOpened
        anchors.fill: parent

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
            bottom: parent.bottom
        }

        height: parent.height
        width: 353
        widget: 'DetailedUserInfo'
        view: 'DetailedUserInfoView'
    }
}
