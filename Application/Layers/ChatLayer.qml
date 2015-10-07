import QtQuick 2.4
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs
import Application.Core 1.0
import Application.Core.Styles 1.0

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
        property bool isDetailedInfoOpened: d.isOpened()

        function isOpened() {
            return userInfo.viewInstance.isOpened ? userInfo.viewInstance.isOpened() : false;
        }
    }

    WidgetContainer {
        anchors.fill: parent
        widget: 'Messenger'
        view: 'Chat'
    }

    Rectangle {
        color: Styles.contentBackgroundDark
        opacity: Styles.darkBackgroundOpacity
        visible: d.isDetailedInfoOpened
        anchors.fill: parent

        CursorMouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursor: Qt.ArrowCursor
            onClicked: SignalBus.closeDetailedUserInfo();
        }
    }

    WidgetContainer {
        id: userInfo

        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        widget: 'DetailedUserInfo'
        view: 'DetailedUserInfoView'
        height: parent.height
    }

}
