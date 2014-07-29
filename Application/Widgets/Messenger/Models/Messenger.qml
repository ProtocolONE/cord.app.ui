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

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../Application/Core/moment.js" as Moment

import "MessengerPrivate.js" as MessengerPrivateJs
import "User.js" as UserJs
import "Message.js" as MessageJs
import "Group.js" as GroupJs
import "../../../Core/App.js" as App

Item {
    id: root

    property string previousJid
    property string selectedJid
    property string selectedGroupId
    property string authedJid: ""

    property bool connecting: false
    property bool connected: false

    signal selectedUserChanged();
    signal messageReceived(string from, string body);

    signal connectedToServer();

    signal talkDateChanged(string jid);
    signal rosterRecieved();

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
        d.updateUserTalkDate(item);
        messageMap.body = body;
        messageMap.type = QXmppMessage.Chat;
        messageMap.state = QXmppMessage.Active;
        xmppClient.sendMessage(user.jid, messageMap);
    }

    function sendInputStatus(user, value) {
        var item = new UserJs.User(usersModel.getById(user.jid), usersModel);
        if (!item.isValid()) {
            return;
        }

        d.updateUserTalkDate(item);
        xmppClient.sendInputStatus(user.jid, value);
    }

    function connect(jid, password) {
        if (root.connecting || root.connected) {
            console.log('Warning! Ask connecting to already connected jabber');
            return;
        }

        user.jid = jid;
        user.userId = UserJs.jidToUser(jid);

        d.loadUserTalkDate(user.userId);

        root.connecting = true;
        root.authedJid = jid;


        console.log( "jid: " + jid);
        //  DEBUG ONLY
        xmppClient.connectToServer(jid, password);

//        xmppClient.configuration.host = "31.25.225.144";
//        xmppClient.configuration.port = "5222";
//        xmppClient.configuration.domain = "qj.gamenet.ru"
//        xmppClient.configuration.user = user.userId;
//        xmppClient.configuration.password = password;
        //xmppClient.connectUsingConfiguration();
    }

    function disconnect() {
        if (!root.connected && !root.connecting) {
            return;
        }

        groupsModel.clear();
        usersModel.clear();
        MessengerPrivateJs.reset();

        xmppClient.disconnectFromServer();
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
        var defaultAvatar = (installPath + "/Assets/Images/Application/Widgets/Messenger/defaultAvatar.png");
        var data = getUser(item.jid);
        if (!data.isValid()) {
            return defaultAvatar;
        }

        return data.avatar || defaultAvatar;
    }

    function lastActivity(item) {
        var data = getUser(item.jid);
        if (!data.isValid()) {
            return -1;
        }

        return data.lastActivity || -1;
    }

    function isSelectedGamenet() {
        var item = root.selectedUser();
        if (!item.isValid()) {
            return false;
        }

        return item.isGamenet;
    }

    function getGamenetUser() {
        return usersModel.getById(UserJs.getGamenetUserJid());
    }

    QtObject {
        id: d

        property int defaultAvatarIndex: 0

        function rosterRecieved() {
            var rosterUsers = xmppClient.rosterManager.getRosterBareJids()
            , currentUserMap = {}
            , removeUsers = [];

            usersModel.beginBatch();
            groupsModel.beginBatch();

            rosterUsers.forEach(function(jid) {
                currentUserMap[jid] = 1;
                d.appendUser(jid);
            });

            usersModel.forEachId(function(id) {
                if (!currentUserMap.hasOwnProperty(id)) {
                    d.removeUserFromGroups(id);
                }
            });

            usersModel.endbatch();
            groupsModel.endbatch();
            root.rosterRecieved();
        }

        function createGamenetUser() {
            if (usersModel.contains(UserJs.getGamenetUserJid())) {
                return;
            }

            usersModel.append(UserJs.createGamenetUser());
        }

        function getDefaultAvatar() {
            d.defaultAvatarIndex = (d.defaultAvatarIndex + 1) % 12;
            var name = "defaultAvatar_" + (d.defaultAvatarIndex + 1) + ".png";
            return installPath + "/Assets/Images/Application/Widgets/Messenger/" + name;
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
                // INFO Никнейм из вкарда мы берем, но сортировка происходит по нику из ростера
                item = new UserJs.User(usersModel.getById(user), usersModel);
                item.nickname = nickname || user;
                // UNDONE set other properties
            } else {
                rawUser = UserJs.createRawUser(user, nickname || user);
                rawUser.avatar = d.getDefaultAvatar();
                rawUser.lastTalkDate = d.getUserTalkDate(rawUser);
                usersModel.append(rawUser);
                xmppClient.vcardManager.requestVCard(user);
                xmppClient.lastActivityManager.requestLastActivity(user);
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
                d.updateUserTalkDate(user);
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

        function updateUserTalkDate(user) {
            var lastDate = Moment.moment(user.lastTalkDate).format('DD.MM.YYYY'),
                nowDate = Moment.moment().format('DD.MM.YYYY'),
                authedUserId;

            if (lastDate === nowDate) {
                return;
            }

            var now = Date.now();
            user.lastTalkDate = now;

            MessengerPrivateJs.lastTalkMap[user.jid] = now;
            authedUserId = root.authedUser().userId;

            Settings.setValue(
                        'qml/messenger/recentconversation/' + authedUserId,
                        'lastTalkDate',
                        JSON.stringify(MessengerPrivateJs.lastTalkMap));

            root.talkDateChanged(user.jid);
        }

        function loadUserTalkDate(userId) {
            var loadString = Settings.value('qml/messenger/recentconversation/' + userId, 'lastTalkDate', "{}");
            try {
                MessengerPrivateJs.lastTalkMap = JSON.parse(loadString);
            } catch(e) {
                console.log(e)
                MessengerPrivateJs.lastTalkMap = {};
            }
        }

        function getUserTalkDate(user) {
            if (!MessengerPrivateJs.lastTalkMap.hasOwnProperty(user.jid)) {
                return 0;
            }

            return MessengerPrivateJs.lastTalkMap[user.jid] || 0;
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

    User {
        id: user
    }

    JabberClient {
        id: xmppClient

        onConnected: {
            console.log("Connected to server ");

            d.createGamenetUser();

            root.connected = true;
            root.connecting = false;

            xmppClient.failCount = 0;
            xmppClient.vcardManager.requestVCard(user.jid);
            user.nickname = user.jid;

            root.connectedToServer();
        }

        onDisconnected: {
            console.log("Disconnected from server j.");
            root.connected = false;
            root.connecting = false;
        }

        onMessageReceived: {
            //console.log('------ !!!', JSON.stringify(message));
            if (message.type !== QXmppMessage.Chat) {
                return;
            }

            var bareJid = UserJs.jidWithoutResource(message.from)
            d.appendMessage(bareJid, message.state, message.body)

            if (message.body) {
                root.messageReceived(bareJid, message.body);
            }
        }

        onPresenceReceived: d.updatePresence(presence);
    }

    Connections {
        target: App.signalBus()
        onLogoutDone: xmppClient.failCount = 0;
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
                item.nickname = vcard.nickName || item.nickname || "";
            }

            if (vcard.extra) {
                item.avatar = vcard.extra.PHOTOURL || item.avatar || "";
            }
        }
    }

    Connections {
        target: xmppClient.lastActivityManager
        onLastActivityUpdated: {
            var item = root.getUser(UserJs.jidWithoutResource(lastActivity.from));
            if (lastActivity.seconds > 0) {
                console.log(lastActivity.from + ": " + lastActivity.seconds);
                item.lastActivity = lastActivity.seconds;
            }
        }
    }
}
