/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
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
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger
import "../../../Models/User.js" as User

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
