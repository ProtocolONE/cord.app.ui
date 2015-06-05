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

Item {
    id: root

    clip: true

    property variant user: MessengerJs.selectedUser(MessengerJs.USER_INFO_JID)

    onUserChanged: {
        if (!user.jid) {
            return;
        }

        messageList.model = MessengerJs.getConversation(user.jid).messages;
    }

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
            var user = MessengerJs.selectedUser();
            if (!user.isValid()) {
                return;
            }

            MessengerJs.getConversation(user.jid).queryLast(number, name);
        }

        function isSelfMessageTest(jid) {
            var user = MessengerJs.authedUser();
            if (!user.jid) {
                return false;
            }

            return user.jid === jid;
        }

        function isSameJid(index, from, fromDay) {
            if (!messageList.model || index <= 0 || index >= messageList.model.count) {
                return true; // UNDONE тут вроде хочется false
            }

            var hitJid = messageList.model.get(index - 1).jid !== from;
            var hitDay = messageList.model.get(index - 1).day !== fromDay;

            return hitJid || hitDay;
        }

        anchors {
            fill: parent
            rightMargin: 1
        }

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
            onIsStatusMessageChanged: messageList.scrollCheck()
            isSelfMessage: messageList.isSelfMessageTest(model.jid)
            firstMessageInGroup: messageList.isSameJid(index, model.jid, model.day)
            onUserClicked: MessengerJs.selectUser(model);
            onLinkActivated:  {
                MessengerJs.instance().messageLinkActivated(root.user, link);
                if (model.type === "invite") {
                    var message = (link === "gamenet://subscription/accept"
                    ? qsTr("MESSAGE_BODY_SUBSCRIPTION_INVITE_ACCEPTED") //"Вы приняли приглашение пользователя " + MessengerJs.getNickname(model)
                    : qsTr("MESSAGE_BODY_SUBSCRIPTION_INVITE_DECLINED")) //"Вы отказали пользователю " + MessengerJs.getNickname(model);

                    message = message.arg(MessengerJs.getNickname(model));
                    messageList.model.setProperty(index, 'text', message);
                }
            }
        }
    }

    ListViewScrollBar {
        id: scroll

        anchors {
            right: messageList.right
            rightMargin: 4
        }
        height: messageList.height
        width: 6
        listView: messageList
        cursorMaxHeight: messageList.height
        cursorMinHeight: 50
        cursorRadius: 4
        color: "#00000000"
        cursorColor: Styles.style.contentBackgroundLight
        cursorOpacity: 0.1
    }

    // INFO лежив вверху поверх чата
    BodyHistoryHeader {
        width: messageList.width
        visible: messageList.count == 0
        onQueryMore: messageList.queryMore(number, name);
    }

}
