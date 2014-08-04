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
    property int currentTime

    property bool connecting: false
    property bool connected: false

    signal selectedUserChanged();
    signal messageReceived(string from, string body);

    signal connectedToServer();

    signal talkDateChanged(string jid);
    signal onlineStatusChanged(string jid);
    signal lastActivityChanged(string jid);
    signal rosterRecieved();

    function init() {
        return {
            client: xmppClient,
            groups: groupsModel,
            users: usersModel,
            user: myUser
        };
    }

    function sendMessage(user, body) {
        var messageMap = {}
        , item;

        if (!usersModel.contains(user.jid))
            return;

        item = root.getUser(user.jid);
        item.appendMessage(myUser.jid, body);
        d.updateUserTalkDate(item);
        messageMap.body = body;
        messageMap.type = QXmppMessage.Chat;
        messageMap.state = QXmppMessage.Active;
        xmppClient.sendMessage(user.jid, messageMap);
    }

    function sendInputStatus(user, value) {
        var item = root.getUser(user.jid);
        if (!item.isValid()) {
            return;
        }

        d.updateUserTalkDate(item);
        xmppClient.sendInputStatus(user.jid, value);
    }

    function connect(server, userId, password) {
        d.serverUrl = server;

        if (root.connecting || root.connected) {
            console.log('Warning! Ask connecting to already connected jabber');
            return;
        }

        var jid = root.userIdToJid(userId);
        myUser.jid = jid;
        myUser.userId = userId;

        d.loadUserTalkDate(myUser.userId);

        root.connecting = true;
        xmppClient.connectToServer(jid, password);
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

    function getUser(jid, type) {
        type = type || MessengerPrivateJs.USER_INFO_FULL;
        if (type === MessengerPrivateJs.USER_INFO_JID) {
            return { jid: jid };
        }

        if (myUser.jid && jid === myUser.jid)
            return myUser;

        return new UserJs.User(usersModel.getById(jid), usersModel, xmppClient);
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

    function selectedUser(type) {
        return root.getUser(root.selectedJid, type);
    }

    function previousUser() {
        return root.getUser(root.previousJid);
    }

    function authedUser() {
        return myUser;
    }

    function userAvatar(item) {
        var defaultAvatar = (installPath + "/Assets/Images/Application/Widgets/Messenger/defaultAvatar.png");
        var data = root.getUser(item.jid);
        if (!data.isValid()) {
            return defaultAvatar;
        }

        return data.avatar || defaultAvatar;
    }

    function lastActivity(item) {
        var data = root.getUser(item.jid);
        if (!data.isValid()) {
            return 0;
        }

        return data.lastActivity || 0;
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

    function openDialog(user) {
        if (!user) {
            return;
        }

        if (!usersModel.contains(user.jid)) {
            d.appendUser(user.jid, user.nickname);
        }

        root.selectUser(user);
    }

    function userIdToJid(userId) {
        return userId + '@' + d.serverUrl;
    }

    QtObject {
        id: d

        property int defaultAvatarIndex: 0
        property string serverUrl: ''

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

        function appendUser(user, externalNickName) {
            var nickname
            , groups
            , item
            , groupsMap = {}
            , rawUser;

            nickname = xmppClient.rosterManager.getNickname(user) || externalNickName;
            groups = xmppClient.rosterManager.getGroups(user);
            groups = (groups.length === 0)
                    ? ['!']
                    : groups;

            if (usersModel.contains(user)) {
                // INFO Никнейм из вкарда мы берем, но сортировка происходит по нику из ростера
                item = root.getUser(user);
                item.nickname = nickname || user;
                // UNDONE set other properties
            } else {
                rawUser = UserJs.createRawUser(user, nickname || user);
                rawUser.lastTalkDate = d.getUserTalkDate(rawUser);
                usersModel.append(rawUser);
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

        function appendMessage(from, state, message, date) {
            var user;

            if (!usersModel.contains(from))
                return;

            user = root.getUser(from);

            if (message) {
                user.appendMessage(from, message, date);
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

            var oldOnline = user.online;
            user.presenceState = presence.type;
            user.statusMessage = presence.status;
            if (user.online !== oldOnline) {
                root.onlineStatusChanged(user.jid);
            }

            if (!user.online) {
                xmppClient.lastActivityManager.requestLastActivity(bareJid);
            }
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

            MessengerPrivateJs.lastTalkDateMap[user.jid] = now;
            authedUserId = root.authedUser().userId;

            Settings.setValue(
                        'qml/messenger/recentconversation/' + authedUserId,
                        'lastTalkDate',
                        JSON.stringify(MessengerPrivateJs.lastTalkDateMap));

            root.talkDateChanged(user.jid);
        }

        function loadUserTalkDate(userId) {
            var loadString = Settings.value('qml/messenger/recentconversation/' + userId, 'lastTalkDate', "{}");
            try {
                MessengerPrivateJs.lastTalkDateMap = JSON.parse(loadString);
            } catch(e) {
                MessengerPrivateJs.lastTalkDateMap = {};
            }
        }

        function getUserTalkDate(user) {
            if (!MessengerPrivateJs.lastTalkDateMap.hasOwnProperty(user.jid)) {
                return 0;
            }

            return MessengerPrivateJs.lastTalkDateMap[user.jid] || 0;
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
        id: myUser
    }

    JabberClient {
        id: xmppClient

        onConnected: {
            console.log("Connected to server ");

            d.createGamenetUser();

            root.connected = true;
            root.connecting = false;

            xmppClient.failCount = 0;
            xmppClient.vcardManager.requestVCard(myUser.jid);
            myUser.nickname = myUser.jid;

            root.connectedToServer();
        }

        onDisconnected: {
            console.log("Disconnected from server j.");
            root.connected = false;
            root.connecting = false;
        }

        onMessageReceived: {
            var messageDate;

            if (message.stamp != "Invalid Date") {
                messageDate = +(Moment.moment(message.stamp));
            }

            if (message.type !== QXmppMessage.Chat) {
                return;
            }

            var bareJid = UserJs.jidWithoutResource(message.from)
            if (!usersModel.contains(bareJid)) {
                d.appendUser(bareJid);
            }

            d.appendMessage(bareJid, message.state, message.body, messageDate)

            if (message.body) {
                root.messageReceived(bareJid, message.body);
            }
        }

        onPresenceReceived: d.updatePresence(presence);

        onLastActivityUpdated: {
            var item = root.getUser(jid);
            if (!item.isValid()) {
                return;
            }

            item.lastActivity = timestamp;
            root.lastActivityChanged(jid);
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 60000
        triggeredOnStart: true
        onTriggered: root.currentTime = Math.floor(Date.now()/1000);
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
                item.avatar = vcard.extra.PHOTOURL || item.avatar;
            }

            if (!item.avatar) {
                item.avatar = d.getDefaultAvatar();
            }
        }
    }


}
