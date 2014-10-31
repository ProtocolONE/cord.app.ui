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

import "./Private" as Private

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../Application/Core/moment.js" as Moment

import "MessengerPrivate.js" as MessengerPrivateJs
import "User.js" as UserJs
import "Message.js" as MessageJs
import "Group.js" as GroupJs

import "../../../Core/App.js" as App
import "../../../Core/User.js" as User

Item {
    id: root

    property string previousJid
    property string selectedJid
    property string selectedGroupId
    property int currentTime

    property variant gamenetUser

    property bool contactReceived: false
    property bool connecting: false
    property bool connected: false
    property bool everConnected: false
    property int currentStatus: d.getCurrentStatus()

    property alias historySaveInterval: xmppClient.historySaveInterval

    signal selectedUserChanged();
    signal messageReceived(string from, string body);

    signal connectedToServer();

    signal talkDateChanged(string jid);
    signal onlineStatusChanged(string jid);
    signal lastActivityChanged(string jid);
    signal rosterReceived();

    function init() {
        return {
            client: xmppClient,
            groups: groupsModel,
            users: usersModel,
            user: myUser
        };
    }

    function getUsersModel() {
        return usersModel;
    }

    function getGroupsModel() {
        return groupsModel;
    }

    function hasUnreadMessages(user) {
        var data = root.getUser(user.jid);
        if (!data.isValid()) {
            return;
        }

        return data.unreadMessageCount > 0;
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
        xmppClient.sendMessageEx(user.jid, messageMap);
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
        UserJs.serverUrl = server;
        if (root.connecting || root.connected) {
            console.log('Warning! Ask connecting to already connected jabber');
            return;
        }

        var jid = root.userIdToJid(userId);
        myUser.jid = jid;
        myUser.userId = userId;

        var options = {};
        var currentTime = new Date();
        options.resource = "QGNA_" + Qt.md5(currentTime.toString() + Math.floor(Math.random() * 100));

        d.loadUserTalkDate(myUser.userId);

        root.connecting = true;
        xmppClient.connectToServerEx(jid, password, options);
    }

    function disconnect() {
        if (!root.connected && !root.connecting) {
            return;
        }

        groupsModel.clear();
        usersModel.clear();
        MessengerPrivateJs.reset();
        root.contactReceived = false;

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
            d.setUnreadMessageForUser(item.jid, 0);
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

    function setGameInfo(info) {
        xmppClient.setGamingInfo(info);
    }

    function clearHistory() {
        xmppClient.clearHistory();
    }

    function getJabberClient() {
        return xmppClient;
    }

    function getPlayingContactsModel() {
        return playingContacts;
    }

    function plainContactsItem() {
        return plainContacts;
    }

    function recentConversationItem() {
        return recentConversation;
    }

    QtObject {
        id: d

        property int defaultAvatarIndex: 0
        property string serverUrl: ''

        function rosterReceived() {
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

            usersModel.endBatch();
            groupsModel.endBatch();
            root.rosterReceived();
            root.contactReceived = true;
        }

        function createGamenetUser() {
            if (usersModel.contains(UserJs.getGamenetUserJid())) {
                return;
            }

            var rawUser = UserJs.createGamenetUser();
            rawUser.statusMessage = qsTr("MESSENGER_GAMENET_USER_STATUS_MESSAGE");
            usersModel.append(rawUser);
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
            , rawUser
            , unreadMessageUsersMap;

            nickname = xmppClient.rosterManager.getNickname(user) || externalNickName;
            groups = xmppClient.rosterManager.getGroups(user);
            unreadMessageUsersMap = d.unreadMessageUsers();
            groups = groups.filter(function(e) {
                return !!e;
            });
            groups = (groups.length === 0)
                    ? [GroupJs.getNoGroupId()]
                    : groups;

            if (usersModel.contains(user)) {
                // INFO Никнейм из вкарда мы берем, но сортировка происходит по нику из ростера
                item = root.getUser(user);
                item.nickname = nickname || item.nickname || user;
                // UNDONE set other properties

                if (unreadMessageUsersMap.hasOwnProperty(item.jid)) {
                    item.unreadMessageCount = unreadMessageUsersMap[item.jid].count;
                }

            } else {
                rawUser = UserJs.createRawUser(user, nickname || user);
                rawUser.lastTalkDate = d.getUserTalkDate(rawUser);

                if (unreadMessageUsersMap.hasOwnProperty(rawUser.jid)) {
                    rawUser.unreadMessageCount = unreadMessageUsersMap[rawUser.jid].count;
                }

                usersModel.append(rawUser);
                if (root.contactReceived) {
                    d.storeRawUser(user);
                }
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
            group = group || GroupJs.getNoGroupId();
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

                if (!user.online) {
                    user.changeState(presence.from, MessageJs.Active);
                }
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

        function unreadMessageUsers() {
            if (MessengerPrivateJs.unreadMessageCountMap) {
                return MessengerPrivateJs.unreadMessageCountMap;
            }

            var storedUsers = {},
                settingsValue = Settings.value('qml/messenger/unreadmessage/', myUser.jid, "{}");

            try {
                storedUsers = JSON.parse(settingsValue);
            } catch(e) {
                storedUsers = {};
            }

            MessengerPrivateJs.unreadMessageCountMap = storedUsers;

            return storedUsers;
        }

        function setUnreadMessageForUser(jid, count) {
            var storedUsers = d.unreadMessageUsers();
            if (count === 0) {
                delete storedUsers[jid];
            } else {
                storedUsers[jid] = {count: count};
            }

            Settings.setValue('qml/messenger/unreadmessage/', myUser.jid, JSON.stringify(storedUsers));

            MessengerPrivateJs.unreadMessageCountMap = storedUsers;
        }

        function getRawUsersMap() {
            var storedUsers = {},
                settingsValue = Settings.value('qml/messenger/stored/', myUser.jid, "{}");

            try {
                storedUsers = JSON.parse(settingsValue);
            } catch(e) {
                storedUsers = {};
            }

            return storedUsers;
        }

        function storeRawUser(jid) {
            var storedUsers = d.getRawUsersMap();
            storedUsers[jid] = {};

            Settings.setValue('qml/messenger/stored/', myUser.jid, JSON.stringify(storedUsers));
        }

        function loadRawUsers() {
            var storedUsers = d.getRawUsersMap();

            Object.keys(storedUsers).forEach(function(e){
                d.appendUser(e);
            });
        }


        function getUserTalkDate(user) {
            if (!MessengerPrivateJs.lastTalkDateMap.hasOwnProperty(user.jid)) {
                return 0;
            }

            return MessengerPrivateJs.lastTalkDateMap[user.jid] || 0;
        }

        function getCurrentStatus() {
            if (root.connected) {
                return root.contactReceived ? MessengerPrivateJs.ROSTER_RECEIVED : MessengerPrivateJs.ROSTER_RECEIVING;
            } else {
                if (root.everConnected) {
                    return MessengerPrivateJs.RECONNECTING;
                }
                return root.connecting ? MessengerPrivateJs.CONNECTING : MessengerPrivateJs.DISCONNECTED;
            }
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
            root.everConnected = true;
            root.connecting = false;

            xmppClient.failCount = 0;
            xmppClient.vcardManager.requestVCard(myUser.jid);
            myUser.nickname = myUser.jid;

            root.connectedToServer();
            root.gamenetUser = root.getGamenetUser();
        }

        onDisconnected: {
            console.log("Disconnected from server j.");
            root.connected = false;
            root.connecting = false;
        }

        onCarbonMessageReceived: {
            if (message.type !== QXmppMessage.Chat || !message.body) {
                return;
            }

            var to = UserJs.jidWithoutResource(message.to);

            if (!usersModel.contains(to)) {
                d.appendUser(to);
            }

            var item = root.getUser(to);
            item.appendMessage(UserJs.jidWithoutResource(message.from), message.body);
            d.updateUserTalkDate(item);
            xmppClient.saveToHistory(to, message);
        }

        onMessageReceived: {
            var messageDate = Date.now();

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

            d.appendMessage(bareJid, message.state, message.body, messageDate);
            xmppClient.saveToHistory(message.from, message, messageDate);

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

        onHistoryReceived: {
            var item = root.getUser(jid), length;
            if (!item.isValid() || !history) {
                return;
            }

            length = history.length;
            for (var i = 0; i < length; ++i) {
                Object.keys(history[i]).forEach(function(e) {
                    var message = history[i][e]
                        , date = +Moment.moment(message.date).startOf('day');

                    item.prependMessage(message.from, message.body, message.date);
                });
            }
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
        target: User.getInstance()
        onNicknameChanged: {
            var user = root.authedUser();
            user.nickname = User.getNickname();
        }
    }

    Connections {
        target: App.signalBus()
        onLogoutDone: {
            myUser.avatar = '';
            xmppClient.failCount = 0;
            MessengerPrivateJs.unreadMessageCountMap = undefined;
        }
    }

    Connections {
        target: xmppClient.rosterManager

        onItemAdded: {
            console.log("Roster item added: " + bareJid);
            //root.contactAdded(bareJid);
            d.rosterReceived();
        }

        onItemChanged: {
            console.log("Roster item changed: " + bareJid, xmppClient.rosterManager.getGroups(bareJid));
            //root.contactChanged(bareJid);
            d.rosterReceived();
        }

        onItemRemoved: {
            console.log("Roster item removed: " + bareJid);
            //root.contactRemoved(bareJid);
            d.rosterReceived();
        }

        onRosterReceived: {
            console.log("ROSTER MANAGER: Roster received");
            d.rosterReceived();
            d.loadRawUsers();
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

    Private.PlayingGame {
        id: playingContacts

        messenger: root
    }

    Private.PlainContacts {
        id: plainContacts

        messenger: root
    }

    Private.RecentConversation {
        id: recentConversation

        messenger: root
    }
}
