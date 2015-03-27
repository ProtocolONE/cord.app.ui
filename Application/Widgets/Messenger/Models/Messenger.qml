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

import "GroupChatManager.js" as GroupChatManager

import "../Plugins/Smiles/Smiles.js" as Smiles


import "../Plugins/Bookmarks/Bookmarks.js" as Bookmarks
import "../Plugins/AutoJoin/Autojoin.js" as Autojoin
import "../Plugins/RoomCreate/RoomCreate.js" as RoomCreate
import "../Plugins/Topic/Topic.js" as Topic

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

    // HACK
    property bool isGroupChatConfigOpen: false

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
            console.log("[ROSTER MANAGER] Item added: " + bareJid);
            d.rosterReceived();
        });

        rosterManager.itemChanged.connect(function(){
            console.log("[ROSTER MANAGER] Item changed: " + bareJid, rosterManager.getGroups(bareJid));
            d.rosterReceived();
        });

        rosterManager.itemRemoved.connect(function(bareJid) {
            console.log("[ROSTER MANAGER] Item removed: " + bareJid);
            d.rosterReceived();
        });

        rosterManager.rosterReceived.connect(function() {
            console.log("[ROSTER MANAGER] Roster received");

            d.rosterReceived();
            d.loadAndUpdateRawUsers();
        });
    }

    function init() {
        Smiles.init(xmppClient);
        Bookmarks.init(xmppClient, root);
        Autojoin.init(xmppClient, root);
        RoomCreate.init(xmppClient, root);
        Topic.init(xmppClient, root);

        AccountManager.init(root, xmppClient, usersModel, {
            defaultAvatarPath: installPath + "/Assets/Images/Application/Widgets/Messenger/"
        });

        ConversationManager.init(xmppClient, conversationModel)
        GroupChatManager.init(xmppClient, d, myUser, root);

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

//    function sendMessage(user, body) {
//        var messageMap = {}
//        , item;

//        if (!usersModel.contains(user.jid))
//            return;

//        item = root.getUser(user.jid);
//        if (item.isGroupChat) {
//            //item.appendMessage(myUser.jid, body);
//            d.updateUserTalkDate(item);

//            xmppClient.mucManager.sendMessage(user.jid, body);

//            Smiles.processSmiles(myUser.jid, body);
//        } else {
//            item.appendMessage(myUser.jid, body);
//            d.updateUserTalkDate(item);
//            messageMap.body = body;
//            messageMap.type = QXmppMessage.Chat;
//            messageMap.state = QXmppMessage.Active;
//            xmppClient.sendMessageEx(user.jid, messageMap);
//            Smiles.processSmiles(myUser.jid, body);
//        }
//    }

//    function sendInputStatus(user, value) {
//        var item = root.getUser(user.jid);
//        if (!item.isValid() || item.isGroupChat) {
//            return;
//        }

//        d.updateUserTalkDate(item);
//        xmppClient.sendInputStatus(user.jid, value);
//    }

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

        usersModel.clear();
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

    // UNDONE надо бы скорее всего это как-то переписать
    function uuid() {
        return Uuid.create();
    }

    function hackJoin() {
        RoomCreate.create({
                              topic: "Good news everyone! " + Date.now(),
                              invites: ['400001000002212660@qj.gamenet.ru']
                          })
        //GroupChatManager.create();
    }

    function hackSetBookMark() {
        Bookmarks.bookmarks.addConference(Date.now() + '@qj.gamenet.ru');
        JSON.stringify(Bookmarks.bookmarks.conference());

//        var test = {
//            urls: [
//                {
//                    url: "http://ya.ru"
//                },
//                {
//                    url: "http://gamenet.ru"
//                }
//            ],
//            conferences: [
//                {
//                    jid: "1@qj.gamenet.ru",
//                    autojoin: true
//                },
//                {
//                    jid: "2@qj.gamenet.ru",
//                    autojoin: true
//                }
//            ]
//        }

//        var test2 = {
//            conferences: [
//                {
//                    jid: "2@qj.gamenet.ru",
//                    autojoin: true
//                }
//            ]
//        }

//        xmppClient.bookmarkManager.setBookmarks(test);
    }

    function hackRemBookMark() {
        var q = Bookmarks.bookmarks.conference();
        Bookmarks.bookmarks.removeConference(q[0]);
        JSON.stringify(Bookmarks.bookmarks.conference());
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
                //console.log('---- ', id)
                var isGroupChat = usersModel.getPropertyById(id, "isGroupChat");
                //if (!isGroupChat)
                {

                    usersModel.setPropertyById(id, "inContacts", true /*currentUserMap.hasOwnProperty(id)*/);
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


        function leave(roomJid, reason) {
            //xmppClient.mucManager.setPermission(roomJid, myUser.jid, 'none');
            xmppClient.mucManager.leave(roomJid, reason || "");
        }

        function invite(roomJid, jid, reason) {
            var bareJid = UserJs.jidWithoutResource(jid)
            xmppClient.mucManager.setPermission(roomJid, bareJid, 'admin');
            xmppClient.mucManager.sendInvitation(roomJid, jid, reason || "");
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


            // UNDONE
//            xmppClient.discoveryManager.requestInfo(d.serverUrl);
//            xmppClient.discoveryManager.requestItems(d.serverUrl);

//            xmppClient.discoveryManager.requestInfo("conference." + d.serverUrl);
            //xmppClient.discoveryManager.requestItems("conference." + d.serverUrl);
//            xmppClient.discoveryManager.requestInfo("test2@conference.qj.gamenet.ru");
//            xmppClient.mucManager.addRoom("test2@conference.qj.gamenet.ru");

            //xmppClient.mucManager.addRoom("test5@conference.qj.gamenet.ru");
//            xmppClient.mucManager.addRoom("test6@conference.qj.gamenet.ru");
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

        onMessageReceived: {
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

        onConfigurationReceived: {
//            console.log('==== onConfigurationReceived', roomJid, JSON.stringify(configuration, null ,2));
//            var password = "";
//            if (roomJid == "test5@conference.qj.gamenet.ru") {
//                password = "123";
//                xmppClient.mucManager.join(roomJid, myUser.userId, password)
//            }

//            if (!xmppClient.mucManager.join(roomJid, myUser.userId, password)) {
//                console.log('failed to join ', roomJid)
//            }
            // + "_roomNick"
        }

        onJoined: {

//            usersModel.beginBatch();
//            var rawUser;
//            if (!usersModel.contains(roomJid)) {
//                rawUser = UserJs.createRawGroupChat(roomJid, roomJid);
//                rawUser.inContacts = true;
//                console.log(JSON.stringify(rawUser, null ,2));
//                usersModel.append(rawUser);
//            } else {

//                console.log('--- contains')
//            }

//            usersModel.endBatch()

//            console.log('=== joined ', roomJid);
//            console.log(JSON.stringify(xmppClient.mucManager.participants(roomJid)))
//            console.log(JSON.stringify(xmppClient.mucManager.participantsFullJid(roomJid)))

//            if (roomJid == "test6@conference.qj.gamenet.ru") {
//                console.log('-------- Set config for test6')
//                if (!xmppClient.mucManager.setConfiguration(roomJid, {
//                                                          description: "описание комнаты 6"
//                                                       })){
//                    console.log('        -         failed to set config');
//                }
//            }
        }

        onMessageReceived: {
//            var user;
//            if (message.type !== QXmppMessage.GroupChat) {
//                return;
//            }

//            if (message.subject) {
//                console.log('----- group chat subject ', roomJid, JSON.stringify(message, null, 2))
//                user = root.getUser(message.from);
//                user.nickname = message.subject;
//                return;
//            }

//            if (!message.body) {
//                console.log('--- empty body')
//                return;
//            }

//            console.log('----- from message ', roomJid, JSON.stringify(message, null, 2))
//            user = root.getUser(message.from);
//            if (!user.isGroupChat) {
//                console.log('--- not a group chat')
//                return;
//            }

//            //console.log('----- frome message ', roomJid, JSON.stringify(message, null, 2))

//            if (d.needIncrementUnread(user)) {
//                user.unreadMessageCount += 1;
//                d.setUnreadMessageForUser(user.jid, user.unreadMessageCount);
//            }

//            if (message.stamp == "Invalid Date") {
//                d.updateUserTalkDate(user);
//            }

            //root.messageReceived(user.jid, message.body, message);

//            var user;

//            if (message.type !== QXmppMessage.Chat || !message.body) {
//                return;
//            }

//            user = root.getUser(message.from);
//            if (d.needIncrementUnread(user)) {
//                user.unreadMessageCount += 1;
//                d.setUnreadMessageForUser(user.jid, user.unreadMessageCount);
//            }

//            if (message.stamp == "Invalid Date") {
//                d.updateUserTalkDate(user);
//            }

//            root.messageReceived(user.jid, message.body, message);


//            var messageDate = Date.now();
//            if (message.stamp != "Invalid Date") {
//                messageDate = +(Moment.moment(message.stamp));
//            }

//            var item = root.getUser(roomJid);
//            if (message.subject) {
//                item.nickname = message.subject;
//                return;
//            }

//            var from = xmppClient.mucManager.participantFullJid(roomJid, message.from);
//            var bareFrom = UserJs.jidWithoutResource(from);

//            console.log('----- frome message ', bareFrom, JSON.stringify(message))
//            item.appendMessage(bareFrom, message.body, messageDate);

//            console.log(roomJid, JSON.stringify(message, null ,2), bareFrom, message.body)
        }

//        onLeft: {
//            console.log('left room ', roomJid)
//        }

        onInvitationReceived: {
            console.log('onInvitationReceived ', roomJid, inviter, reason);
        }
    }

//    Connections {
//        target: xmppClient.discoveryManager

//        onInfoReceived: {
//            console.log('---- infoReceived ', JSON.stringify(info, null ,2));
////            console.log(info.id)
//        }
//        onItemsReceived: {
//            console.log('---- itemsReceived ', JSON.stringify(items, null ,2));
//        }
//    }

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

        messenger: root
    }

    UserModels.RecentConversation {
        id: recentConversation

        pauseProcessing: root.heavyInteraction
        messenger: root
    }

    ExtendedListModel {
        id: conversationModel

        idProperty: 'id'
    }
}
