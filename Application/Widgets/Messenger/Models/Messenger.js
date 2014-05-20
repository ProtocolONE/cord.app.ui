.pragma library

var visibleItems = {};

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

var dataModel;
dataModel = _modelInstance.init();

function instance() {
    return _modelInstance;
}

// HACK для отладки
var connectGuard = false;
function connect(user, password) {
    if (connectGuard) {
        console.log('Connect gruard: already connected.');
        return;
    }

    var server = "j.gamenet.dev"
    var bareJid = user + "@" + server;

    connectGuard = true;
    _modelInstance.connect(bareJid, password);
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

function selectUser(user, group) {
    _modelInstance.selectUser(user, group);
}

function selectedUser() {
    return _modelInstance.selectedUser();
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

function getNickname(item) {
    if (!item.jid) {
        throw new Error('Error getNickname. Object has not property jid.' + JSON.stringify(item))
    }

    return getUser(item.jid).nickname;
}

function closeChat() {
    _modelInstance.closeChat();
}

function hasUnreadMessages(user) {
    var data = getUser(user.jid);
    if (!data.isValid()) {
        return;
    }

    return data.unreadMessageCount > 0;
}

function userStatusMessage(user) {
    var data = getUser(user.jid);
    if (!data.isValid()) {
        return;
    }

    return data.statusMessage;
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

    return _modelInstance.selectedUser().messages
}

function eachUser(callback) {
    users().forEach(callback);
}

