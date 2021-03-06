var _jabber = null;

function setTopic(roomJid, topic) {
    _jabber.setRoomTopic(roomJid, topic);
}

function init(jabber, messenger) {
    var _messenger = messenger;

    if (_jabber) {
        throw new Error("[Topic] Already initialized");
    }

    _jabber = jabber;
    _jabber.mucManager.messageReceived.connect(function(roomJid, message) {
        var user;
        if (message.type !== 3) { // QXmppMessage.GroupChat
            return;
        }

        if (!message.subject) {
            return;
        }

        user = _messenger.getUser(roomJid);
        user.rosterNickname = message.subject;
    });
}
