import QtQuick 2.4
import Application.Core.Styles 1.0

import "../../../Models/Messenger.js" as Messenger

Item {
    id: root

    property variant privateItem: Messenger.getRecentConversationItem()
    property bool hasContacts: root.privateItem.count > 0

    Connections {
        target: privateItem || null
        onDataChanged: scrollbar.positionViewAtBeginning();
    }

    ListView {
        id: listView

        model: root.privateItem.proxyModel
        anchors {
            fill: parent
            rightMargin: 12
        }

        boundsBehavior: Flickable.StopAtBounds
        clip: true

        section.property: "sectionId"
        section.delegate: RecentDateHeader {
            width: listView.width
            caption: root.privateItem.sectionCaption(section)
        }

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

        text: qsTr("MESSENGER_RECENT_CONTACTS_EMPTY_INFO")
        wrapMode: Text.Wrap
        color: Styles.textBase
        font {
            family: "Arial"
            pixelSize: 14
            bold: false
        }
    }

    ContactsScrollBar {
        id: scrollbar

        listView: listView
        anchors.left: listView.right
    }
}
