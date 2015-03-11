/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../../../../Application/Core/moment.js" as Moment

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger
import "../../../Models/User.js" as User

Item {
    id: root

    property variant privateItem: Messenger.getRecentConversationItem()

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
            onClicked: select();
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
        color: Styles.style.messengerRecentContactEmptyInfo
        font {
            family: "Arial"
            pixelSize: 14
            bold: false
        }
    }

    ListViewScrollBar {
        id: scrollbar

        anchors.left: listView.right
        height: listView.height
        width: 10
        listView: listView
        cursorMaxHeight: listView.height
        cursorMinHeight: 50
        color: Styles.style.messangerContactScrollBar
        cursorColor: Styles.style.messangerContactScrollBarCursor
    }
}
