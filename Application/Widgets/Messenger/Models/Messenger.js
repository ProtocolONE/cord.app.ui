/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
.pragma library

var USER_INFO_FULL = 1;
var USER_INFO_JID = 2;

var DISCONNECTED     = 0;
var CONNECTING       = 1;
var ROSTER_RECEIVING = 2;
var ROSTER_RECEIVED  = 3;
var RECONNECTING     = 4;

var _modelComponent,
    _modelInstance;

if (!_modelComponent) {
    _modelComponent = Qt.createComponent('./Messenger.qml');
    if (_modelComponent.status === 1) {
        _modelInstance = _modelComponent.createObject(null);
    } else {
        console.log('Can\'t create Messenger.qml', _modelComponent.errorString());
    }
}

var dataModel = _modelInstance.init();

function instance() {
    return _modelInstance;
}

function connect(server, user, password) {
    _modelInstance.connect(server, user, Qt.md5(password));
}

function disconnect() {
    _modelInstance.disconnect();
}

function users() {
    return dataModel.users;
}

function getUser(jid) {
    return _modelInstance.getUser(jid);
}

function getConversation(jid) {
   return _modelInstance.getConversation(jid);
}

function authedUser() {
    return _modelInstance.authedUser();
}

function selectUser(user) {
    _modelInstance.selectUser(user);
}

function selectedUser(type) {
    return _modelInstance.selectedUser(type);
}

function previousUser() {
    return _modelInstance.previousUser();
}

function setSmilePanelVisible(value) {
    _modelInstance.setSmilePanelVisible(value);
}

function smilePanelVisible() {
    return _modelInstance.smilePanelVisible();
}

function getNickname(item) {
    if (!item) {
        return "";
    }

    if (!item.hasOwnProperty('jid')) {
        throw new Error('Error getNickname. Object has not property jid.' + JSON.stringify(item));
    }

    return _modelInstance.getNickname(item);
}

function closeChat() {
    _modelInstance.closeChat();
}

function hasUnreadMessages(user) {
    return _modelInstance.hasUnreadMessages(user);
}

function unreadMessagesCount(user) {
    return _modelInstance.unreadMessagesCount(user);
}

function userStatusMessage(user) {
    var data = getUser(user.jid);
    if (!data.isValid()) {
        return;
    }

    return data.statusMessage;
}

function userPlayingGame(user) {
    var data = getUser(user.jid);
    if (!data.isValid()) {
        return "";
    }

    return data.playingGame;
}

function userPresenceState(user) {
    return _modelInstance.userPresenceState(user.jid);

//    var data = getUser(user.jid);
//    if (!data.isValid()) {
//        return;
//    }

//    return data.presenceState;
}

function isSelectedUser(user) {
    return _modelInstance.isSelectedUser(user);
}

function userSelected() {
    return !!_modelInstance.selectedJid;
}

function selectedUserNickname() {
    if (!userSelected()) {
        return "";
    }

    return _modelInstance.selectedUser().nickname;
}

function eachUser(callback) {
    users().forEach(callback);
}

function userAvatar(item) {
    return _modelInstance.userAvatar(item);
}

function userLastActivity(item) {
    return _modelInstance.lastActivity(item);
}

function isSelectedGamenet() {
    return _modelInstance.isSelectedGamenet();
}

function isGamenetUser(item) {
    return _modelInstance.isGamenetUser(item.jid);
}

function isConnecting() {
    return _modelInstance.connecting;
}

function isConnected() {
    return _modelInstance.connected;
}

function getGamenetUser() {
    return _modelInstance.gamenetUser;
}

function openDialog(user) {
    _modelInstance.openDialog(user);
}

function userIdToJid(userId) {
  return _modelInstance.userIdToJid(userId);
}

function jidToUser(jid) {
  return _modelInstance.jidToUser(jid);
}

function setGameInfo(info) {
  _modelInstance.setGameInfo(info);
}

function gamePlayingByUser(item) {
    if (!item) {
        return "";
    }

    if (!item.hasOwnProperty('jid')) {
        throw new Error('Error gamePlayingByUser. Object has not property jid.' + JSON.stringify(item));
    }

    var user = getUser(item.jid);
    if (!user || !user.isValid()) {
        return "";
    }

    return user.playingGame;
}

function clearHistory() {
    _modelInstance.clearHistory();
}

function getPlayingContactsModel() {
    return _modelInstance.getPlayingContactsModel();
}

function getRecentConversationItem() {
    return _modelInstance.recentConversationItem();
}

function getAllContactsItem() {
    return _modelInstance.allContactsItem();
}

function isContactReceived() {
    return _modelInstance.contactReceived;
}

function getStatus() {
    return _modelInstance.currentStatus;
}

function setHeavyInteraction(value) {
    _modelInstance.heavyInteraction = value;
}

function editGroupModel() {
    return _modelInstance.editGroupModel();
}

function leaveGroup(roomJid) {
    _modelInstance.leaveGroup(roomJid);
}

function getGroupTitle(user) {
    return _modelInstance.getGroupTitle(user);
}

function getFullStatusMessage(user) {
    return _modelInstance.getFullStatusMessage(user);
}

function changeOwner(roomJid, user) {
    _modelInstance.changeOwner(roomJid, user);
}

function renameUser(user, newValue) {
    _modelInstance.renameUser(user, newValue);
}

function changeGroupTopic(roomJid, newValue) {
    _modelInstance.changeGroupTopic(roomJid, newValue);
}

function addContact(jid) {
    _modelInstance.addContact(jid);
}

function removeContact(user) {
    _modelInstance.removeContact(user);
}

function isGameNetMember(user) {
    return _modelInstance.isGameNetMember(user);
}

