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
import QXmpp 1.0
import GameNet.Controls 1.0

import "MessengerPrivate.js" as MessengerPrivateJs
import "User.js" as UserJs
import "Message.js" as MessageJs
import "Group.js" as GroupJs

Item {
    id: root

    property string previousJid
    property string selectedJid
    property string selectedGroupId
    property string authedJid: ""

    signal selectedUserChanged();

    function init() {
        return {
            client: xmppClient,
            groups: groupsModel,
            users: usersModel,
            user: user
        };
    }

    function sendMessage(user, body) {
        var messageMap = {}
            , item;

        if (!usersModel.contains(user.jid))
            return;

        item = new UserJs.User(usersModel.getById(user.jid), usersModel);
        item.appendMessage(root.authedJid, body);
        messageMap.body = body;
        messageMap.type = QXmppMessage.Chat;
        messageMap.state = QXmppMessage.Active;
        xmppClient.sendMessage(user.jid, messageMap);
    }

    function sendInputStatus(user, value) {
        var messageMap = {}
            , item;
        item = new UserJs.User(usersModel.getById(user.jid), usersModel);
        if (!item.isValid()) {
            return;
        }

        messageMap.type = QXmppMessage.Chat;
        if (value === "Active") {
            messageMap.state = QXmppMessage.Active;
        }

        if (value === "Composing") {
            messageMap.state = QXmppMessage.Composing;
        }

        if (value === "Inactive") {
            messageMap.state = QXmppMessage.Inactive;
        }

        if (value === "Paused") {
            messageMap.state = QXmppMessage.Paused;
        }

        xmppClient.sendMessage(user.jid, messageMap);
    }

    function connect(jid, password) {
        root.authedJid = jid;
        user.jid = jid;
        user.userId = UserJs.jidToUser(jid);
        xmppClient.connectToServer(jid, password)
    }

    function getUser(jid) {
        if (root.authedJid && jid === root.authedJid)
            return user;

        return new UserJs.User(usersModel.getById(jid), usersModel);
    }

    function isSelectedUser(user) {
        return user.jid === root.selectedJid;
    }

    function isSelectedGroup(group) {
        return group.groupId === root.selectedGroupId;
    }

    function setGroupOpened(group, value) {
        var item;
        if (!groupsModel.contains(group.groupId)) {
            console.log('Error group not found', group.groupId);
            return;
        }

        item = new GroupJs.Group(groupsModel.getById(group.groupId), groupsModel);
        item.opened = value;
    }

    function selectUser(user, group) {
        var item;

        root.previousJid = root.selectedJid;
        root.selectedJid = user ? (user.jid || "") : "";
        root.selectedGroupId = group ? (group.groupId || "") : "";

        item = root.getUser(user.jid);
        if (item.isValid()) {
            item.unreadMessageCount = 0;
            item.hasUnreadMessage = false;
        }

        root.selectedUserChanged();
    }

    function closeChat() {
        root.selectUser({jid:""}, {groupId: ""});
    }

    function selectedUser() {
        return new UserJs.User(usersModel.getById(root.selectedJid), usersModel);
    }

    function previousUser() {
        return new UserJs.User(usersModel.getById(root.previousJid), usersModel);
    }

    function authedUser() {
        return user;
    }

    function userAvatar(item) {
        var defaultAvatar = (installPath + "/images/Application/Widgets/Messenger/defaultAvatar.png");
        var data = getUser(item.jid);
        if (!data.isValid()) {
            return defaultAvatar;
        }

        return data.avatar || defaultAvatar;
    }

    function isSelectedGamenet() {
        var item = root.selectedUser();
        if (!item.isValid()) {
            return false;
        }

        return item.isGamenet;
    }

    Component.onCompleted: {
        d.appendGamenetUser();
    }

    QtObject {
        id: d

        property int defaultAvatarIndex: 0

        function appendGamenetUser() {
            var gamenetUser = UserJs.createGamenetUser(),
                gamenetGroup = GroupJs.createGamenetGroup(),
                group;

            usersModel.append(gamenetUser);
            groupsModel.append(gamenetGroup);

            group = new GroupJs.Group(groupsModel.getById(gamenetGroup.groupId), groupsModel);
            group.appendUser(gamenetUser.jid);
        }

        function rosterRecieved() {
            var rosterUsers = xmppClient.rosterManager.getRosterBareJids()
            , currentUserMap = {}
            , removeUsers = [];

            rosterUsers.forEach(function(jid) {
                currentUserMap[jid] = 1;
                d.appendUser(jid);
            });

            usersModel.forEachId(function(id) {
                if (!currentUserMap.hasOwnProperty(id)) {
                    d.removeUserFromGroups(id);
                }
            });
        }

        function getDefaultAvatar() {
            d.defaultAvatarIndex = (d.defaultAvatarIndex + 1) % 12;
            var name = "defaultAvatar_" + (d.defaultAvatarIndex + 1) + ".png";
            return installPath + "/images/Application/Widgets/Messenger/" + name;
        }

        function appendUser(user) {
            var nickname
            , groups
            , item
            , groupsMap = {}
            , rawUser;

            nickname = xmppClient.rosterManager.getNickname(user);
            groups = xmppClient.rosterManager.getGroups(user);
            groups = (groups.length === 0)
                    ? ['!']
                    : groups;

            if (usersModel.contains(user)) {
                // UNDONE Если никнейм из берем из vcard то убрать
                item = new UserJs.User(usersModel.getById(user), usersModel);
                //item.nickname = nickname || user;
                // UNDONE set other properties
            } else {
                rawUser = UserJs.createRawUser(user, nickname || user);
                rawUser.avatar = d.getDefaultAvatar();
                usersModel.append(rawUser);
                xmppClient.vcardManager.requestVCard(user);
            }

            groups.forEach(function(group) {
                groupsMap[group] = 1;
                d.appendUserToGroup(group, user);
            });

            MessengerPrivateJs.userGroups(user).forEach(function(g) {
                if (!groupsMap.hasOwnProperty(g)) {
                    d.removeUserFromGroup(g, user);
                }
            });
        }

        function removeUserFromGroup(group, user) {
            var count, i;
            if (!MessengerPrivateJs.isUserInGroup(group, user)) {
                return;
            }

            MessengerPrivateJs.removeUserFromGroup(group, user);

            count = groupsModel.getById(group).users.count;
            for (i = count - 1; i >=0; --i) {
                if (groupsModel.getById(group).users.get(i).jid === user) {
                    groupsModel.getById(group).users.remove(i);
                    break;
                }
            }

            if (groupsModel.getById(group).users.count === 0) {
                groupsModel.removeById(group);
            }
        }

        function removeUserFromGroups(user) {
            groupsModel.forEachId(function (id) {
                d.removeUserFromGroup(id, user);
            });
        }

        function appendUserToGroup(groupId, user) {
            // UNDONE нет сортировки пользоватей внутри группы и групп
            // При сортировке не забыть про псевдо группу "Gamenet" и "!"
            var group;

            if (!groupsModel.contains(groupId)) {
                groupsModel.append(GroupJs.createRawGroup(groupId));
            }

            if (!MessengerPrivateJs.isUserInGroup(groupId, user)) {
                MessengerPrivateJs.appendUserToGroup(groupId, user);
                group = new GroupJs.Group(groupsModel.getById(groupId), groupsModel);
                group.appendUser(user);
            }
        }

        function appendMessage(from, state, message) {
            var user;

            if (!usersModel.contains(from))
                return;

            user = new UserJs.User(usersModel.getById(from), usersModel);

            if (message) {
                user.appendMessage(from, message);
                if (!root.isSelectedUser(user)) {
                    user.unreadMessageCount += 1;
                }

            } else {
                user.changeState(from, state);
            }
        }

        function updatePresence(presence) {
            var bareJid = UserJs.jidWithoutResource(presence.from)
            var user = root.getUser(bareJid);
            if (!user.isValid()) {
                return;
            }

            user.presenceState = presence.type;
            user.statusMessage = presence.status;
        }
    }

    ExtendedListModel {
        id: groupsModel

        idProperty: "groupId"
    }

    ExtendedListModel {
        id: usersModel

        idProperty: "jid"
    }

    QtObject {
        id: user

        property string nickname: ""
        property string jid: ""
        property string userId: ""
        property int state: QXmppMessage.Active
        property string presenceState: ""
        property string statusMessage: ""
        property string avatar: installPath + "/images/Application/Widgets/Messenger/defaultAvatar.png";
        property int unreadMessageCount: 0

        function isValid() {
            return true;
        }
    }

    QXmppClient {
        id: xmppClient

//                logger: QXmppLogger {
//                    loggingType: QXmppLogger.FileLogging
//                    logFilePath: "D:\XmppClient.log"
//                    messageTypes: QXmppLogger.AnyMessage
//                }

        onConnected: {
            //root.isConnected = true;
            console.log("Connected to server ");
            //root.connected();
            xmppClient.vcardManager.requestVCard(user.jid);
            user.nickname = user.jid;
        }

        onDisconnected: {
            console.log("Disconnected from server j.");
            //root.disconnected();
        }

        onMessageReceived: {
            //console.log('------ !!!', JSON.stringify(message));
            var bareJid = UserJs.jidWithoutResource(message.from)
            if (message.type === QXmppMessage.Chat) {
                d.appendMessage(bareJid, message.state, message.body)
            }

        }

        //        onError: {
        ////            if (error == XmppClient.SocketError) {
        ////                console.log("Error due to TCP socket.");
        ////            } else if (error == XmppClient.KeepAliveError) {
        ////                console.log("Error due to no response to a keep alive.");
        ////            } else if (error == XmppClient.XmppStreamError) {
        ////                console.log("Error due to XML stream.");
        ////            }
        //        }

        onPresenceReceived: d.updatePresence(presence);
    }

    Connections {
        target: xmppClient.rosterManager

        onItemAdded: {
            console.log("Roster item added: " + bareJid);
            //root.contactAdded(bareJid);
            d.rosterRecieved();
        }

        onItemChanged: {
            console.log("Roster item changed: " + bareJid, xmppClient.rosterManager.getGroups(bareJid));
            //root.contactChanged(bareJid);
            d.rosterRecieved();
        }

        onItemRemoved: {
            console.log("Roster item removed: " + bareJid);
            //root.contactRemoved(bareJid);
            d.rosterRecieved();
        }

        onRosterReceived: {
            console.log("ROSTER MANAGER: Roster received");
            d.rosterRecieved();
        }
    }

    Connections {
        target: xmppClient.vcardManager

        onVCardReceived: {
            //console.log('---------- ', JSON.stringify(vcard), vcard.nickName)
            var item = root.getUser(UserJs.jidWithoutResource(vcard.from));
            //if (vcard.from === user.jid)
            { // INFO пока что берем никнейм из ростера
                item.nickname = vcard.nickName || "";
            }

            if (vcard.extra) {
                item.avatar = vcard.extra.PHOTOURL || "";
            }
        }
    }
}
