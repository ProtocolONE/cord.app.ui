/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

import "../../../Models/Messenger.js" as Messenger

Item {
    id: root

    property variant privateItem: Messenger.getAllContactsItem()
    property bool hasContacts: root.privateItem.count > 0

    ListView {
        id: listView

        model: privateItem.model
        anchors {
            fill: parent
            rightMargin: 12
        }

        boundsBehavior: Flickable.StopAtBounds
        clip: true
        cacheBuffer: 200

        onContentYChanged: {
            if (contentY == 0) {
                scrollBar.positionViewAtBeginning();
            }
        }

        delegate: ContactItemDelegate {
            width: listView.width
            user: model
        }
    }

    ContactsScrollBar {
        id: scrollBar

        listView: listView
        anchors.left: listView.right
    }
}
