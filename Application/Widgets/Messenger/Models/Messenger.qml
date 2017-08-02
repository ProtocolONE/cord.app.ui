/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Tulip 1.0
import QXmpp 1.0
import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.JobWorker 1.0
import GameNet.Components.ItemModel 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0

import "./UserModels" as UserModels

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
import "../Plugins/Logger/Logger.js" as LoggerPlugin

import Application.Widgets.Messenger.Models.Managers 1.0
import Application.Widgets.Messenger.Plugins.Subscription 1.0

import "../Plugins/MessageUrlHandler"

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
    signal carbonMessageReceived(string to);

    signal beforeConnect(string bareJid);
    signal connectedToServer();

    signal talkDateChanged(string jid);
    signal onlineStatusChanged(string jid);
    signal lastActivityChanged(string jid);
    signal nicknameChanged(string jid);
    signal participantsChanged(string jid);
    signal playingGameChanged(string jid);

    signal rosterReceived();

    signal messageLinkActivated(variant user, string link);
    signal messageRead(string jid);

    signal recentConversationsReady(variant jids);

    Component.onCompleted: {
        var rosterManager = xmppClient.rosterManager;

        rosterManager.itemAdded.connect(function(bareJid) {
            console.log("[Roster] Item added: " + bareJid);

            var user = root.getUser(bareJid);
            d.updateNickname(bareJid, user);
            d.updateSubscription(user);
        });

        rosterManager.itemChanged.connect(function(bareJid){
            console.log("[Roster] Item changed: " + bareJid);

            var user = root.getUser(bareJid);
            d.updateSubscription(user);
            d.updateNickname(bareJid, user);
        });

        rosterManager.itemRemoved.connect(function(bareJid) {
            console.log("[Roster] Item removed: " + bareJid);

            var user = root.getUser(bareJid);
            user.subscription = 0;
            user.inContacts = false;
            usersModel.sourceChanged();
        });

        rosterManager.rosterReceived.connect(function(){
            console.log("[Roster] Roster received");

            d.rosterReceived();
        });
    }

    function init() {
        LoggerPlugin.init(xmppClient);

        Smiles.init(xmppClient);
        Events.init(xmppClient, SignalBus);

        Bookmarks.init(xmppClient, root);
        Autojoin.init(xmppClient, root);
        RoomCreate.init(xmppClient, root);
        Topic.init(xmppClient, root);
        RoomParticipants.init(xmppClient, root);
        ChatCommands.init(xmppClient);
        Subscription.init(xmppClient, root, d);

        AccountManager.init(root, xmppClient, usersModel, {
            defaultAvatarPath: installPath + "/Assets/Images/Application/Widgets/Messenger/"
        });

        ConversationManager.init(xmppClient, conversationModel, root);
        RecentConversations.init(xmppClient, conversationModel, root);

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

    function unreadMessagesCount(user) {
        var data = root.getUser(user.jid);
        if (!data.isValid()) {
            return false;
        }

        return data.unreadMessageCount;
    }

    function connect(server, userId, password) {

        console.log('connect to jabber ' + server);
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

        root.connecting = true;

        root.beforeConnect(jid);
        xmppClient.connectToServerEx(jid, password, options);
    }

    function disconnect() {
        console.log('disconnect from jabber');

        if (!root.connected && !root.connecting) {
            return;
        }

        xmppClient.disconnectFromServer();
        root.connected = false;
        root.connecting = false;
        root.contactReceived = false;

        myUser.reset();

        worker.clear();

        root.closeChat();
        groupEditModel.reset();

        allContacts.reset();
        playingContacts.reset();
        recentConversation.reset();
        conversationModel.clear();

        MessengerPrivateJs.shortInfoQueue = {};

        // Очистка вынесеная в отложенный воркер, чтоб при логауте очистилась модель usersModel чуть позже,
        // иначе при биндинге UI пользователи снова докидываются в модель.
        worker.push(new MessengerPrivateJs.ClearUsersModel({ model: usersModel }));
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
            root.messageRead(item.jid);
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
        if (!root.connected) {
            return "";
        }

        var defaultAvatar = (installPath + "/Assets/Images/Application/Widgets/Messenger/defaultAvatar.png");
        var data = root.getUser(item.jid);

        if (!data.isValid()) {
            return defaultAvatar;
        }

        return data.avatar || defaultAvatar;
    }

    function getNickname(item) {
        if (!root.connected) {
            return "";
        }

        var user = getUser(item.jid);
        if (!user || !user.isValid()) {
            return "";
        }

        return user.nickname || item.jid;
    }

    function userPresenceState(jid) {
        if (usersModel.contains(jid)) {
            return usersModel.getById(jid).presenceState;
        } else if (jid == myUser.jid) {
            return myUser.presenceState;
        }
        return "offline";
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

    function isGamenetUser(jid) {
        return jid == UserJs.getGamenetUserJid();
    }

    function isSelectedGamenet() {
        return root.selectedJid == UserJs.getGamenetUserJid();
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
            , occupant
            , keys;

        if (!item.isValid() || !item.isGroupChat) {
            return "";
        }

        if (item.rosterNickname) {
            return item.rosterNickname;
        }

        keys = item.participants.keys();

        keys.forEach(function(k) {
            occupant = root.getUser(k);
            if (occupant.nickname) {
                tmp.push(occupant.nickname);
            }
        });

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

    function renameUser(user, newValue) {
        if (!user || !user.jid) {
            return;
        }

        var clearNewNickname = StringHelper.stripTags(newValue);
        xmppClient.rosterManager.renameItem(user.jid, clearNewNickname);
    }

    function changeGroupTopic(roomJid, newValue) {
        xmppClient.setRoomTopic(roomJid, newValue)
    }

    function addContact(jid) {
        xmppClient.rosterManager.subscribe(jid, myUser.nickname);
    }

    function removeContact(user) {
        if (!user || !user.jid) {
            return;
        }

        xmppClient.rosterManager.removeItem(user.jid);
    }

    function isGameNetMember(user) {
        var data = root.getUser(user.jid);
        if (!data.isValid()) {
            return false;
        }

        return !!data.isGameNetMember;
    }

    onHistorySaveIntervalChanged: {
        ConversationManager.setHistorySaveInterval(historySaveInterval);
    }

    QtObject {
        id: d

        property string serverUrl: ''
        property bool smilePanelVisible: false

        function updateNickname(fullJid, user, externalNickName) {
            var nickname = xmppClient.rosterManager.getNickname(fullJid) || externalNickName;
            user.rosterNickname = nickname || "";
        }

        function updateSubscription(user) {
            var subscription = xmppClient.rosterManager.getSubscription(user.jid);
            user.subscription = subscription;
            user.inContacts = subscription === QXmppRosterManager.Both;
        }

        function rosterReceivedCb() {
            usersModel.endBatch();
            root.rosterReceived();
            root.contactReceived = true;
        }

        function workerAppend(user) {
            if (user == myUser.jid) {
                return;
            }

            var user1 = root.getUser(user);
            d.updateSubscription(user1);
            d.updateNickname(user, user1)
        }

        function rosterReceived() {
            var rosterUsers = xmppClient.rosterManager.getRosterBareJids()
            , currentUserMap = {}
            , removeUsers = [];

            rosterUsers = rosterUsers.filter(function(u) {
              var validContactPattern = new RegExp("^[0-9]+@" + d.serverUrl);
              return validContactPattern.test(u);
            });

            usersModel.beginBatch();

            worker.push(new MessengerPrivateJs.InsertUsersToModel({
                                                           index: 0,
                                                           users: rosterUsers,
                                                           cb: d.workerAppend,
                                                           finish: d.rosterReceivedCb,
                                                           model: usersModel
                                                       }));
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
            , unreadMessageUsersMap
            , subscription;

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
            subscription = xmppClient.rosterManager.getSubscription(bareJid);

            unreadMessageUsersMap = d.unreadMessageUsers();

            if (!usersModel.contains(bareJid)) {
                rawUser = UserJs.createRawUser(fullJid, nickname || "");
                rawUser.lastTalkDate = RecentConversations.getUserTalkDate(rawUser);
                rawUser.subscription = subscription;
                rawUser.inContacts = (subscription == QXmppRosterManager.Both);

                usersModel.append(rawUser);
            }

            // INFO Никнейм из вкарда мы берем теперь только в крайнем случаи
            // Основным никнеймом считаетеся никнейм из ростера
            item = root.getUser(fullJid);

            // UNDONE set other properties
            if (unreadMessageUsersMap.hasOwnProperty(item.jid)) {
                item.unreadMessageCount = unreadMessageUsersMap[item.jid].count;
            }
        }

        function appendGroudUser(fullJid, externalNickName) {
            var rawUser = UserJs.createRawGroupChat(fullJid, externalNickName || "");
            rawUser.lastTalkDate = RecentConversations.getUserTalkDate(rawUser);
            usersModel.append(rawUser);
        }

        function updatePresence(presence) {
            var user = root.getUser(presence.from);
            if (!user.isValid()) {
                return;
            }

            if (user.isGroupChat) {
                return;
            }

            // INFO чую теперь нельзя проверять перед присвоением, что свойство поменялось, ибо оно может
            // меняться сейчас в отложенном коде, и тут снвоа вернется в первоначальное состояние.
            user.presenceState = presence.type;
            user.statusMessage = presence.status;
        }

        function presenceChanged(jid, oldValue, newValue) {
            var onlineOld = UserJs.isOnline(oldValue);
            var onlineNew = UserJs.isOnline(newValue);
            if (onlineOld == onlineNew)  {
                return;
            }

            root.onlineStatusChanged(jid);

            if (!onlineNew) {
                var conf = getConversation(jid);
                conf.changeState(jid, MessageJs.Active);
                xmppClient.requestLastActivityAsync(jid, true);
            }
        }

        function unreadMessageUsers() {
            if (MessengerPrivateJs.unreadMessageCountMap) {
                return MessengerPrivateJs.unreadMessageCountMap;
            }

            if (!myUser.jid) {
                return {};
            }

            var storedUsers = {},
                settingsValue = AppSettings.value('qml/messenger/unreadmessage/', myUser.jid, "{}");

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

            AppSettings.setValue('qml/messenger/unreadmessage/', myUser.jid, JSON.stringify(storedUsers));

            MessengerPrivateJs.unreadMessageCountMap = storedUsers;
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

        function isShortInfoRequested(jid) {
            return MessengerPrivateJs.shortInfoQueue.hasOwnProperty(jid);
        }

        function requestShortInfo(jid) {
            if (d.isShortInfoRequested(jid)) {
                return;
            }

            var userId = root.jidToUser(jid);

            RestApi.Core.execute('user.getProfile',
                                 {
                                     profileId: userId,
                                     shortInfo: 1
                                 },
                                 true, d.shotInfoRequestCallback);
        }

        function shotInfoRequestCallback(response) {
            try {
                var userInfo = response.userInfo[0];
                var groupMember = userInfo.shortInfo.groupMember || "";
                var userId = userInfo.userId;
                var jid = root.userIdToJid(userId);
                var user = root.getUser(jid);
                if (!user.isValid()) {
                    return;
                }

                MessengerPrivateJs.shortInfoQueue[jid] = 1;
                user.isGameNetMember = (Lodash._.indexOf(groupMember.split(','), 'labelInChat') !== -1);
            } catch(e) {
            }
        }
    }

//    ExtendedListModel {
//        id: usersModel

//        idProperty: "jid"
//    }

    ItemModel {
        id: usersModel

        indexProperty: "jid"
        prototype: usersModelComponent
        notifableProperty: [
            "rosterNickname", "presenceState", "lastActivity", "lastTalkDate", "inContacts",
            "playingGame", "unreadMessageCount", "vcardNickname",
        ]
        onPropertyChanged: {
            switch (key) {
                case "lastTalkDate": root.talkDateChanged(id); break;
                case "rosterNickname": root.nicknameChanged(id); break;
                case "vcardNickname": root.nicknameChanged(id); break;
                case "lastActivity": root.lastActivityChanged(id); break;
                case "presenceState": d.presenceChanged(id, oldValue, newValue); break;
                case "inContacts": {
                    if (root.contactReceived) {
                        // INFO заставляем пересчитаться контакт листы на изменении inConacts, но только после
                        // того как получим список контактов
                        usersModel.sourceChanged();
                    }
                    break;
                }
                case "unreadMessageCount": d.setUnreadMessageForUser(id, newValue);
                case "playingGame": root.playingGameChanged(id); break;
            }

            //console.log("usersModel property changed ", id, key, oldValue, newValue);
        }

        onUpdatePropertyRequest: {
            if (key == "isGameNetMember") {
                d.requestShortInfo(id);
            }
        }
    }

    Component {
        id: usersModelComponent

        UserModelItem {
        }
    }

    MessengerAuthedUser {
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
                lastMessageDate = ConversationManager.ConversationStorage.queryLastMessageDate(roomJid) * 1000;
            } catch(e) {
                console.log("[JabberClient] Can't get last message date for", roomJid);
            }

            xmppClient.joinRoomInternal(roomJid, myUser.userId, lastMessageDate);
        }

        function setRoomTopic(roomJid, topic) {
            var clearTopic = StringHelper.stripTags(topic);
            xmppClient.mucManager.setSubject(roomJid, clearTopic);
        }

        function newGroupMessageReceived(roomJid, message) {
            var user;

            user = root.getUser(message.to);
            if (d.needIncrementUnread(user)) {
                usersModel.incrementProperty(user.jid, 'unreadMessageCount', 1);
            } else {
                root.messageRead(user.jid);
            }
            root.messageReceived(user.jid, message.body, message);
        }

        function requestLastActivityAsync(jid, force) {
            if (!force && xmppClient.isLastActivityRequested(jid)) {
                return;
            }

            worker.pushOnce(new MessengerPrivateJs.RequestLastActivity({
                                                           jid: jid,
                                                           jabber: xmppClient,
                                                           messenger: root,
                                                           force: force
                                                       }));
        }

        function requestVCardAsync(jid) {
            if (xmppClient.isVcardRequested(jid)) {
                return;
            }

            worker.pushOnce(new MessengerPrivateJs.RequestVcard({
                                                           jid: jid,
                                                           jabber: xmppClient,
                                                           messenger: root
                                                       }));
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

            root.carbonMessageReceived(message.to);
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
            } else {
                root.messageRead(user.jid);
            }

            root.messageReceived(user.jid, message.body, message);
        }

        onLastActivityUpdated: {
            var user = root.getUser(jid);
            user.lastActivity = timestamp;
        }

        onPresenceReceived: d.updatePresence(presence);
    }

    Timer {
        running: true
        repeat: true
        interval: 60000
        triggeredOnStart: true
        onTriggered: root.currentTime = Math.floor(Date.now()/1000);
    }

    Connections {
        target: User
        onNicknameChanged: {
            var user = root.authedUser();
            user.nickname = User.getNickname();
        }
    }

    Connections {
        target: SignalBus
        onLogoutDone: {
            myUser.avatar = '';
            xmppClient.failCount = 0;
            MessengerPrivateJs.unreadMessageCountMap = undefined;
        }
    }

    Connections {
        target: SignalBus

        onApplicationActivated: {
            resetUnreadDelay.resetForJid = root.selectedJid;
            resetUnreadDelay.restart();
        }
    }

    Connections {
        target: RecentConversations
        onReady: root.recentConversationsReady(jids);
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
            root.messageRead(user.jid);

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

    MessageUrlHandler {
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

    JobWorker {
        id: worker

        interval: 10
        managed: true
    }
}
