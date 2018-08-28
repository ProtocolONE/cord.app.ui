import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

import "../../../Models/Messenger.js" as MessengerJs

import "./Body.js" as BodyJs

Item {
    id: root

    clip: true

    property variant user: MessengerJs.selectedUser(MessengerJs.USER_INFO_JID)

    signal editMessage(variant message);

    onUserChanged: {
        if (!user.jid) {
            return;
        }
        messageList.model = MessengerJs.getConversation(user.jid).messages;
    }

    function contextMenuClicked(messageItem, message, action) {
            switch(action) {
            case "edit":
                root.editMessage(message)
                break;
        }
        Ga.trackEvent('MessageItem', 'context menu click', action);
    }

    Component {
        id: modelItemContextMenu

        ContextMenuView {
            id: itemContextMenu

            property variant message
            property variant messageItem
            property bool showEditButton: false
            property bool showQuoteButton: false

            onContextClicked: {
                root.contextMenuClicked(messageItem, message, action)
                ContextMenu.hide();
            }

            Component.onCompleted: {
                var options = [];

                if (showEditButton) {
                options.push({
                                 name: qsTr("EDIT_ITEM_CONTEXT_MENU"),// "Редактирование",
                                 action: "edit"
                             });
                }

                if (showQuoteButton) {
                options.push({
                                 name: qsTr("QUOTE_ITEM_CONTEXT_MENU"),// "Цитировать",
                                 action: "quote"
                             });
                }

                if (options.length > 0) {
                    fill(options);
                }
                else {
                    ContextMenu.cancel();
                }

            }
        }
    }

    ListView {
        id: messageList

        property bool isFirstPass: false

        cacheBuffer: 100
        boundsBehavior: Flickable.StopAtBounds
        interactive: true

        onModelChanged: {
            messageList.isFirstPass = true;
            messageList.scrollCheck();
        }

        function scrollCheck() {
            if (messageList.isFirstPass && BodyJs.hasSavedScroll(user.jid))  {
                BodyJs.scrollToSaved(scroll, user.jid);
                messageList.isFirstPass = false;
                return;
            }

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

        function isMessageTimeValid(messageItem) {
            var result = false;

            var diff = (Date.now() - messageItem.date)/1000;

            if (diff <= 1800) { // 30 minutes to go
                result = true;
            }

            return result;
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
            id: messageItemId

            width: root.width
            nickname: MessengerJs.getNickname(model)
            avatar: MessengerJs.userAvatar(model)
            date: Qt.formatDateTime(new Date(+model.date), "hh:mm")
            fulldate: model.date
            body: model.text
            isReplacedMessage: model.edited === 1

            isStatusMessage: model.isStatusMessage
            isInviteMessage: model.type === "invite"
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

            isGameNetMember: MessengerJs.isGameNetMember(model);

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: {
                    var isGroup = MessengerJs.selectedUser().isGroupChat;
                    var showFlag = !isGroup && messageItemId.isSelfMessage && messageList.isMessageTimeValid(model);
                    var showQuoteFlag = !messageItemId.isStatusMessage && !messageItemId.isInviteMessage;
                    ContextMenu.show(mouse, messageItemId, modelItemContextMenu, { message: model, messageItem: messageItemId, showEditButton : showFlag, showQuoteButton :showQuoteFlag });
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
        cursorColor: Styles.contentBackgroundLight
        cursorOpacity: 0.1
        onScrolling: BodyJs.saveScroll(user.jid, index, mode);
    }

    // INFO лежив вверху поверх чата
    BodyHistoryHeader {
        width: messageList.width
        visible: messageList.count == 0
        onQueryMore: messageList.queryMore(number, name);
    }

    Connections {
        target: SignalBus
        onLogoutDone: BodyJs.resetSavedScroll();
    }
}
