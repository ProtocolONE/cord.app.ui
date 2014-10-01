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
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger
import "../../../Models/User.js" as User

Item {
    id: root

    property variant privateItem: Messenger.getPlainContactsItem()

    ListView {
        id: listView

        model: privateItem.proxyModel
        anchors {
            fill: parent
            rightMargin: 10
        }

        boundsBehavior: Flickable.StopAtBounds
        clip: true
        section.property: "sectionId"
        cacheBuffer: 300
        section.delegate: GroupHeader {
            width: listView.width
            height: !!section ? 33 : 0
            visible: !!section
            opened: true
            groupName: Messenger.getGroupName({groupId: section})
            usersCount: section ? privateItem.userCount(section) : 0
            onClicked: privateItem.closeGroup(section)
        }

        onContentYChanged: {
            if (contentY == 0)
                scrollBar.positionViewAtBeginning();
        }

        delegate: Item {
            width: listView.width
            height: (model.isGroupItem ? 33 : 53)

            GroupHeader {
                width: listView.width
                height: 33
                visible: model.isGroupItem
                opened: false
                groupName: Messenger.getGroupName(model)
                usersCount: model.isGroupItem ? privateItem.userCount(model.value) : 0
                onClicked: privateItem.openGroup(model.value, index)
                unreadUsersCount: model.isGroupItem ? privateItem.countUnreadUsers(model.value) : 0
            }

            ContactItemDelegate {
                anchors.fill: parent
                visible: !model.isGroupItem
                user: model
                group: model
                onClicked: select();
            }
        }
    }

    ListViewScrollBar {
        id: scrollBar

        anchors.left: listView.right
        height: listView.height
        width: 10
        listView: listView
        cursorMaxHeight: listView.height
        cursorMinHeight: 50
        color: Styles.style.messangerContactScrollBar
        cursorColor: Styles.style.messangerContactScrollBarCursor
    }

    ListModel {
        id: groupProxyModel
    }
}

