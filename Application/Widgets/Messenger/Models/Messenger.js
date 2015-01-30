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

function groups() {
    return dataModel.groups;
}

function groupsModel() {
    return dataModel.groups.model;
}

function users() {
    return dataModel.users;
}

function getUser(jid) {
    return _modelInstance.getUser(jid);
}

function authedUser() {
    return _modelInstance.authedUser();
}

function selectUser(user, group) {
    _modelInstance.selectUser(user, group);
}

function selectedUser(type) {
    return _modelInstance.selectedUser(type);
}

function previousUser() {
    return _modelInstance.previousUser();
}

function sendMessage(user, message) {
    _modelInstance.sendMessage(user, message);
}

function sendInputStatus(user, value) {
    _modelInstance.sendInputStatus(user, value);
}

function setGroupOpened(groupId, value) {
    _modelInstance.setGroupOpened(groupId, value);
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

    var user = getUser(item.jid);
    if (!user || !user.isValid()) {
        return "";
    }

    return user.nickname;
}

function getGroupName(item) {
    if (!item) {
        return "";
    }

    if (!item.hasOwnProperty('groupId')) {
        throw new Error('Error getGroupName. Object has not property groupId.' + JSON.stringify(item));
    }

    return _modelInstance.getGroupName(item);
}

function closeChat() {
    _modelInstance.closeChat();
}

function hasUnreadMessages(user) {
    return _modelInstance.hasUnreadMessages(user);
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
    var data = getUser(user.jid);
    if (!data.isValid()) {
        return;
    }

    return data.presenceState;
}

function isSelectedUser(user) {
    return _modelInstance.isSelectedUser(user);
}

function isSelectedGroup(group) {
    return _modelInstance.isSelectedGroup(group);
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

function selectedUserMessages() {
    if (!userSelected()) {
        return [];
    }

    return _modelInstance.selectedUser().messages;
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
    var user = getUser(item.jid);
    if (!user.isValid()) {
        return false;
    }

    return user.isGamenet;
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

    for (var i = 0; i < users().count; ++i) {
        var actualUser = users().get(i);
        actualUser.messages.clear();
    }
}

function checkHistoryInterval() {
    _modelInstance.checkHistoryInterval();
}

function getPlayingContactsModel() {
    return _modelInstance.getPlayingContactsModel();
}

function getPlainContactsItem() {
    return _modelInstance.plainContactsItem();
}

function getRecentConversationItem() {
    return _modelInstance.recentConversationItem();
}

function isContactReceived() {
    return _modelInstance.contactReceived;
}

function getStatus() {
    return _modelInstance.currentStatus;
}
