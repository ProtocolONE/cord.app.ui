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
import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs
import "../../../../../Core/moment.js" as Moment

Rectangle {
    color: Styles.style.messengerChatDialogBodyBackground
    clip: true

    ListView {
        id: messageList

        cacheBuffer: 100
        boundsBehavior: Flickable.StopAtBounds
        interactive: true

        function scrollCheck() {
            var hasNotScroll = messageList.contentHeight < messageList.height;
            if (hasNotScroll || scroll.isAtEnd()) {
                scrollToEndTimer.restart();
            }
        }

        function queryMore(number, name) {
            var user = MessengerJs.selectedUser(MessengerJs.USER_INFO_JID);
            if (!user || !user.jid) {
                return;
            }

            user = MessengerJs.getUser(user.jid);

            if (!user || !user.isValid) {
                return;
            }

            user.queryMoreMessages(number, name);
        }

        anchors {
            fill: parent
            rightMargin: 1
        }

        model: MessengerJs.selectedUserMessages()

        Timer {
            id: scrollToEndTimer
            /*
              INFO
              т.к onCountChanged меняется на каждое добавление елемента в ListModel
              пришлось написать этот хак. Если сделать scroll.positionViewAtEnd()
              непосредственно в onCountChanged, не правильно просчитывается высота + не обновляются секции.
              Скролл в низ нужно делать с небольшой задержкой.
            */

            interval: 25
            onTriggered: scroll.positionViewAtEnd();
        }

        onCountChanged: messageList.scrollCheck();

        header: BodyHistoryHeader {
            width: messageList.width
            visible: messageList.count > 0
            onQueryMore: messageList.queryMore(number, name);
        }

        section.property: "day"
        section.delegate: BodySection {
            width: messageList.width
            sectionProperty: section
        }

        delegate: MessageItem {
            width: root.width
            nickname: MessengerJs.getNickname(model)
            avatar: MessengerJs.userAvatar(model)
            date: Qt.formatDateTime(new Date(+model.date), "hh:mm")
            body: model.text
            isStatusMessage: model.isStatusMessage
            onIsStatusMessageChanged: messageList.scrollCheck();
        }
    }

    ListViewScrollBar {
        id: scroll

        anchors {
            right: messageList.right
            rightMargin: 1
        }
        height: messageList.height
        width: 10
        listView: messageList
        cursorMaxHeight: messageList.height
        cursorMinHeight: 50
        color: Styles.style.messangerChatDialogScrollBar
        cursorColor: Styles.style.messangerChatDialogScrollBarCursor
    }

    BodyHistoryHeader {
        width: messageList.width
        visible: messageList.count == 0
        onQueryMore: messageList.queryMore(number, name);
    }

    Rectangle {
        width: 1
        height: parent.height
        color: Qt.lighter(parent.color, Styles.style.lighterFactor)
        anchors.right: parent.right
    }
}
