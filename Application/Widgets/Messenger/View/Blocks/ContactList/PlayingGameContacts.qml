import QtQuick 2.4
import Application.Core.Styles 1.0

import "../../../Models/Messenger.js" as Messenger

Item {
    id: root

    ListView {
        id: listView

        model: Messenger.getPlayingContactsModel().model

        anchors {
            fill: parent
            rightMargin: 12
        }

        boundsBehavior: Flickable.StopAtBounds
        clip: true

        delegate: ContactItemDelegate {
            width: listView.width
            user: model
        }
    }

    Text {
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        visible: listView.count === 0

        text: qsTr("MESSENGER_PLAYING_CONTACTS_EMPTY_INFO")
        wrapMode: Text.Wrap
        color: Styles.textBase
        font {
            family: "Arial"
            pixelSize: 14
        }
    }

    ContactsScrollBar {
        id: scrollBar

        listView: listView
        anchors.left: listView.right
    }
}
