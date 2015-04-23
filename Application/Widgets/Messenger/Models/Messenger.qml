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

import "./UserModels" as UserModels

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../Application/Core/moment.js" as Moment

import "MessengerPrivate.js" as MessengerPrivateJs
import "User.js" as UserJs
import "Message.js" as MessageJs

import "ConversationManager.js" as ConversationManager
import "AccountManager.js" as AccountManager

import "../Plugins/Smiles/Smiles.js" as Smiles
import "../Plugins/Events/Events.js" as Events

import "../Plugins/Bookmarks/Bookmarks.js" as Bookmarks
import "../Plugins/AutoJoin/Autojoin.js" as Autojoin
import "../Plugins/RoomCreate/RoomCreate.js" as RoomCreate
import "../Plugins/Topic/Topic.js" as Topic
import "../Plugins/RoomParticipants/RoomParticipants.js" as RoomParticipants
import "../Plugins/ChatCommands/ChatCommands.js" as ChatCommands

import "../../../Core/App.js" as App
import "../../../Core/User.js" as User

Item {
    id: root

    property string previousJid
    property string selectedJid
    property int currentTime

    property variant gamenetUser

    property bool contactReceived: false
    property bool connecting: false
    property bool connected: false
    property bool everConnected: false
    property int currentStatus: d.getCurrentStatus()
    property bool heavyInteraction: false

    property string historySaveInterval

    signal selectedUserChanged();
    signal messageReceived(string from, string body, variant message);

    signal connectedToServer();

    signal talkDateChanged(string jid);
    signal onlineStatusChanged(string jid);
    signal lastActivityChanged(string jid);

    signal nicknameChanged(string jid);
    signal rosterReceived();

    Component.onCompleted: {
        var rosterManager = xmppClient.rosterManager;

        rosterManager.itemAdded.connect(function(bareJid) {
            console.log("[Roster] Item added: " + bareJid);
            d.rosterReceived();
        });

        rosterManager.itemChanged.connect(function(){
            console.log("[Roster] Item changed: " + bareJid, rosterManager.getGroups(bareJid));
            d.rosterReceived();
        });

        rosterManager.itemRemoved.connect(function(bareJid) {
            console.log("[Roster] Item removed: " + bareJid);
            d.rosterReceived();
        });

        rosterManager.rosterReceived.connect(function(){
            console.log("[Roster] Roster received");

            d.rosterReceived();
            d.loadAndUpdateRawUsers();
        });
    }

    function init() {
        Smiles.init(xmppClient);
        Events.init(xmppClient, App.signalBus());

        Bookmarks.init(xmppClient, root);
        Autojoin.init(xmppClient, root);
        RoomCreate.init(xmppClient, root);
        Topic.init(xmppClient, root);
        RoomParticipants.init(xmppClient, root);
        ChatCommands.init(xmppClient);

        AccountManager.init(root, xmppClient, usersModel, {
            defaultAvatarPath: installPath + "/Assets/Images/Application/Widgets/Messenger/"
        });

        ConversationManager.init(xmppClient, conversationModel)

        return {
            client: xmppClient,
            users: usersModel,
            user: myUser
        };
    }

    function getUsersModel() {
        return usersModel;
    }

    function hasUnreadMessages(user) {
        var data = root.getUser(user.jid);
        if (!data.isValid()) {
            return false;
        }

        return data.unreadMessageCount > 0;
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
        var currentTime = Date.now();
        options.resource = "QGNA_" + currentTime.toString() + Math.floor(Math.random() * 100);
        options.streamManagementMode = 1;

        d.loadUserTalkDate(myUser.userId);

        root.connecting = true;

        xmppClient.connectToServerEx(jid, password, options);
    }

    function disconnect() {
        if (!root.connected && !root.connecting) {
            return;
        }

        root.connected = false;

        root.closeChat();
        groupEditModel.reset();
        usersModel.clear();
        myUser.reset();
        root.contactReceived = false;

        xmppClient.disconnectFromServer();
    }

    function getUser(jid, type) {
        var userJid = UserJs.jidWithoutResource(jid || ""),
            userType = type || MessengerPrivateJs.USER_INFO_FULL;

        if (userType === MessengerPrivateJs.USER_INFO_JID) {
            return { jid: userJid };
        }

        if (myUser.jid && userJid === myUser.jid)
            return myUser;

        if (-1 !== userJid.indexOf('@') && !usersModel.contains(userJid)) {
            d.appendUser(userJid);
        }

        return new UserJs.User(usersModel.getById(userJid), usersModel, xmppClient);
    }

    function getConversation(id) {
        return ConversationManager.create(id);
    }

    function getUserGroups(user) {
        var u = root.getUser(user.jid);
        return u.isValid() ? u.groups : [];
    }

    function isSelectedUser(user) {
        return user.jid === root.selectedJid;
    }

    function selectUser(user) {
        var item;

        root.previousJid = root.selectedJid;
        root.selectedJid = user ? (user.jid || "") : "";

        item = root.getUser(user.jid);
        if (item.isValid()) {
            item.unreadMessageCount = 0;
            item.hasUnreadMessage = false;
            d.setUnreadMessageForUser(item.jid, 0);
        }

        root.selectedUserChanged();
    }

    function closeChat() {
        root.selectUser({jid:""});
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

    function getFullStatusMessage(user) {
        var item;
        if (!user) {
            return "";
        }

        item = root.getUser(user.jid);
        if (!item.isValid()) {
            return "";
        }

        if (UserJs.isOnline(item.presenceState)) {
            var serviceId = item.playingGame;
            if (serviceId) {
                var gameInfo = App.serviceItemByServiceId(serviceId);
                if (gameInfo) {
                    return qsTr("MESSENGER_CONTACT_ITEM_PLAYING_STATUS_INFO").arg(gameInfo.name);
                }
            }

            return item.statusMessage;
        }

        var lastActivity = item.lastActivity;
        if (!lastActivity) {
            return "";
        }

        var currentTime = Math.max(root.currentTime * 1000, Date.now());
        return qsTr("LAST_ACTIVITY_PLACEHOLDER").arg(Moment.moment(lastActivity * 1000).from(currentTime));
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

    function openDialog(options) {
        if (!options) {
            return;
        }

        if (!usersModel.contains(options.jid)) {
            d.appendUser(options.jid, options.nickname);
        }

        root.selectUser(options);
    }

    function userIdToJid(userId) {
        return userId + '@' + d.serverUrl;
    }

    function jidToUser(jid) {
        return UserJs.jidToUser(jid);
    }

    function setGameInfo(info) {
        xmppClient.setGamingInfo(info);
    }

    function clearHistory() {
        ConversationManager.clearHistory();
    }

    function getJabberClient() {
        return xmppClient;
    }

    function getPlayingContactsModel() {
        return playingContacts;
    }

    function recentConversationItem() {
        return recentConversation;
    }

    function allContactsItem() {
        return allContacts;
    }

    function setSmilePanelVisible(value) {
        d.smilePanelVisible = value;
    }

    function smilePanelVisible() {
        return d.smilePanelVisible;
    }

    function getGroupTitle(user) {
        if (!user) {
            return "";
        }

        var tmp = []
            , i
            , item = root.getUser(user.jid)
            , occupant;

        if (!item.isValid() || !item.isGroupChat) {
            return "";
        }

        if (item.nickname) {
            return item.nickname;
        }

        for(i = 0; i < item.participants.count; ++i) {
            occupant = root.getUser(item.participants.get(i).jid);
            tmp.push(occupant.nickname);
        }

        return tmp.join(", ");
    }

    function uuid() {
        return Uuid.create();
    }

    function editGroupModel() {
        return groupEditModel;
    }

    function createRoom(jid, topic, invites) {
        RoomCreate.create({
                              jid: jid,
                              topic: topic,
                              invites: invites
                          });
    }

    function leaveGroup(roomJid) {
        xmppClient.leaveGroup(roomJid);
    }

    function changeOwner(roomJid, user) {
        xmppClient.mucManager.setPermission(roomJid, user.jid, "owner");
        xmppClient.mucManager.setPermission(roomJid, myUser.jid, "member");
    }

    onHistorySaveIntervalChanged: {
        ConversationManager.setHistorySaveInterval(historySaveInterval);
    }

    QtObject {
        id: d

        property string serverUrl: ''
        property bool smilePanelVisible: false

        function rosterReceived() {
            var rosterUsers = xmppClient.rosterManager.getRosterBareJids()
            , currentUserMap = {}
            , removeUsers = [];

            usersModel.beginBatch();

            rosterUsers.forEach(function(jid) {
                currentUserMap[jid] = 1;
                d.appendUser(jid);
            });

            usersModel.forEachId(function(id) {
                var isGroupChat = usersModel.getPropertyById(id, "isGroupChat");
                if (!isGroupChat) {
                    usersModel.setPropertyById(id, "inContacts", currentUserMap.hasOwnProperty(id));
                }
            });

            usersModel.endBatch();
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

        function appendUser(fullJid, externalNickName) {
            var nickname
            , groups
            , item
            , groupsMap = {}
            , rawUser
            , unreadMessageUsersMap;

            if (!fullJid) {
                return;
            }

            var bareJid = UserJs.jidWithoutResource(fullJid);
            if (bareJid === myUser.jid) {
                return;
            }

            nickname = xmppClient.rosterManager.getNickname(fullJid) || externalNickName;
            groups = xmppClient.rosterManager.getGroups(fullJid);

            nickname = xmppClient.rosterManager.getNickname(fullJid) || externalNickName;
            groups = xmppClient.rosterManager.getGroups(fullJid);

            unreadMessageUsersMap = d.unreadMessageUsers();
            groups = groups.filter(function(e) {
                return !!e;
            });

            if (!usersModel.contains(bareJid)) {
                rawUser = UserJs.createRawUser(fullJid, nickname || fullJid);
                rawUser.groups = groups.map(function(g){ return {name: g}; });
                rawUser.lastTalkDate = d.getUserTalkDate(rawUser);

                usersModel.append(rawUser);
                if (root.contactReceived) {
                    d.storeRawUser(fullJid);
                }
            }

            // INFO Никнейм из вкарда мы берем, но сортировка происходит по нику из ростера
            item = root.getUser(fullJid);
            item.nickname = nickname || item.nickname || fullJid;
            item.groups = groups;

            // UNDONE set other properties
            if (unreadMessageUsersMap.hasOwnProperty(item.jid)) {
                item.unreadMessageCount = unreadMessageUsersMap[item.jid].count;
            }
        }

        function appendGroudUser(fullJid, externalNickName) {
            usersModel.append(UserJs.createRawGroupChat(fullJid, externalNickName || ""));
        }

        function updatePresence(presence) {
            var user = root.getUser(presence.from);
            if (!user.isValid()) {
                return;
            }

            if (user.isGroupChat) {
                return;
            }

            var oldOnline = user.online;
            if (user.presenceState !== presence.type) {
                user.presenceState = presence.type;
            }

            if (user.statusMessage !== presence.status) {
                user.statusMessage = presence.status;
            }

            if (user.online !== oldOnline) {
                root.onlineStatusChanged(user.jid);
                if (!user.online) {
                    var conf = getConversation(user.jid);
                    conf.changeState(presence.from, MessageJs.Active);
                }
            }

            if (!user.online) {
                xmppClient.lastActivityManager.requestLastActivity(user.jid);
            }
        }

        function updateUserTalkDateHandler(jid) {
            var item = root.getUser(jid);
            d.updateUserTalkDate(item);
        }

        function updateUserTalkDate(user) {
            if (!user.isValid()) {
                return;
            }

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

        function loadAndUpdateRawUsers() {
            var storedUsers = d.getRawUsersMap();

            Object.keys(storedUsers).forEach(function(e){
                if (!usersModel.contains(e) && e !== myUser.jid) {
                    d.appendUser(e);
                } else {
                    delete storedUsers[e];
                }
            });

            Settings.setValue('qml/messenger/stored/', myUser.jid, JSON.stringify(storedUsers));
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
		
		function needIncrementUnread(user) {
            var allWindowsInactive = !App.overlayChatVisible() && !Qt.application.active;

            return !root.isSelectedUser(user) || allWindowsInactive;
        }
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

        signal bookmarksReceived(variant bookmarks);
        signal chatCommand(string jid, string body);

        function isConnected() {
            return root.connected;
        }

        function joinRoom(roomJid) {
            var lastMessageDate = 0;
            try {
                lastMessageDate = ConversationManager.ConversationStorage.queryLastMessageDate(roomJid);
            } catch(e) {
                console.log("[JabberClient] Can't get last message date for", roomJid);
            }

            xmppClient.joinRoomInternal(roomJid, myUser.userId, lastMessageDate);
        }

        onStreamManagementResumed: {
            if (!resumed) {
                return;
            }
            console.log('Connection resumed');

            root.connected = true;
            root.everConnected = true;
            root.connecting = false;

            xmppClient.failCount = 0;
        }

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
            var user;
            if (message.type !== QXmppMessage.Chat || !message.body) {
                return;
            }

            user = root.getUser(message.to);
            d.updateUserTalkDate(user);
        }

        onMessageReceivedEx: {
            var user;

            if (message.type !== QXmppMessage.Chat || !message.body) {
                return;
            }

            user = root.getUser(message.from);
            if (d.needIncrementUnread(user)) {
                user.unreadMessageCount += 1;
                d.setUnreadMessageForUser(user.jid, user.unreadMessageCount);
            }

            if (message.stamp == "Invalid Date") {
                d.updateUserTalkDate(user);
            }

            root.messageReceived(user.jid, message.body, message);
        }

        onLastActivityUpdated: {
            var user = root.getUser(jid);
            user.lastActivity = timestamp;
            root.lastActivityChanged(user.jid);
        }

        onPresenceReceived: d.updatePresence(presence);
        onInputStatusSending: d.updateUserTalkDateHandler(jid)
        onMessageSending: d.updateUserTalkDateHandler(jid)
    }

    Connections {
        target: xmppClient.mucManager

        onMessageReceived: {
            var user;

            if (message.type !== QXmppMessage.GroupChat || !message.body) {
                return;
            }

            if (message.subject) {
                return;
            }

            var bareJid = UserJs.jidWithoutResource(message.from),
                conv;

            if (message.from === bareJid) {
                return;
            }

            user = root.getUser(message.from);
            if (d.needIncrementUnread(user)) {
                user.unreadMessageCount += 1;
                d.setUnreadMessageForUser(user.jid, user.unreadMessageCount);
            }

            if (message.stamp == "Invalid Date") {
                d.updateUserTalkDate(user);
            }

            root.messageReceived(user.jid, message.body, message);
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
        target: App.mainWindowInstance()

        onWindowActivated: {
            resetUnreadDelay.resetForJid = root.selectedJid;
            resetUnreadDelay.restart();
        }
    }

    Timer {
        id: resetUnreadDelay

        property string resetForJid

        interval: 1000
        repeat: false
        onTriggered: {
            var user;

            if (!Qt.application.active) {
                return;
            }

            if (root.selectedJid !== resetUnreadDelay.resetForJid) {
                return;
            }

            user = root.getUser(resetUnreadDelay.resetForJid);
            if (!user.isValid()) {
                return;
            }

            user.unreadMessageCount = 0;
            d.setUnreadMessageForUser(user.jid, user.unreadMessageCount);

            resetUnreadDelay.resetForJid = "";
        }
    }

    UserModels.PlayingGame {
        id: playingContacts

        pauseProcessing: root.heavyInteraction
        messenger: root
    }

    UserModels.AllContacts {
        id: allContacts

        pauseProcessing: root.heavyInteraction
        messenger: root
    }

    UserModels.RecentConversation {
        id: recentConversation

        pauseProcessing: root.heavyInteraction
        messenger: root
    }

    GroupEditModel {
        id: groupEditModel

        messenger: root
    }

    ExtendedListModel {
        id: conversationModel

        idProperty: 'id'
    }
}
