.pragma library

Qt.include("./Helpers/TimeHelper.js");
Qt.include("./ConversationStorage.js");
Qt.include("./Conversation.js");

var _ref = null,
    _private,
    _modelComponent,
    _modelInstance,
    _jabber = null,
    _jid,
    _db;

_private = {
    getHistorySaveDuration: function(value) {
        if (value == "-1") {
            return false;
        }

        if (value == "0") {
            return true;
        }

        var interval = value.split(' ');
        return startOfDay(subtractTime(Date.now(), interval[0], interval[1]));
    },


    jidWithoutResource: function (jid) {
        var pos = jid.indexOf('/');
        return pos < 0 ? jid : jid.substring(0, pos);
    },
    chatFullJidToUser: function (roomJid) {
        var pos = roomJid.indexOf('/');
        if (pos < 0 || pos >= roomJid.length) {
            return roomJid;
        }

        return roomJid.substring(pos+1) + "@" + _jabber.serverUrl();
    },
    wrapMessage: function(message) {
        var result = {
            body: message.body,
            to: message.to,
            from: message.from,
            type: message.type,
            stamp: message.stamp,
            state: message.state,
            isAttentionRequested: message.isAttentionRequested,
            isReceiptRequested: message.isReceiptRequested,
            mucInvitationJid: message.mucInvitationJid,
            mucInvitationPassword: message.mucInvitationPassword,
            mucInvitationReason: message.mucInvitationReason,
            receiptId: message.receiptId,
            thread: message.thread,
            id: message.id,
            isReplaceMessage: message.isReplaceMessage,
            replaceId: message.replaceId
        }

        return result;
    }
};

function init(jabber, extendedListModel, messenger) {
    console.log('[Conversation] Init', extendedListModel, jabber);

    if (_ref !== null) {
        throw new Error('Conversation manager already initialized');
    }

    _ref = extendedListModel;
    _modelComponent = Qt.createComponent('./Storage.qml');
    if (_modelComponent.status !== 1) {
        throw new Error('Can\'t create Storage.qml ' + _modelComponent.errorString());
    }

    _modelInstance = _modelComponent.createObject(_ref);

    _jabber = jabber;

    _jabber.connected.connect(function() {
        //console.log('[Conversation] Init Conversation manager for ', _jabber.myJid);

        _jid = _jabber.myJid;
        _db = _modelInstance.getDb(_jid);

        ConversationStorage.init(_db);
    });

     _jabber.carbonMessageReceived.connect(function(message) {
         var toBareJid = _private.jidWithoutResource(message.to),
             fromBareJid = _private.jidWithoutResource(message.from),
             conv,
             tmpMessage;

         if (message.type !== 2 /*QXmppMessage.Chat*/ || !message.body) {
             return;
         }

         //INFO Debug purposes
         //console.log('[Conversation] CarbonMessageReceived', JSON.stringify(message));
         conv = create(toBareJid);
         tmpMessage = _private.wrapMessage(message);
         conv.receiveMessage(fromBareJid, tmpMessage);
     });

    _jabber.messageReceivedEx.connect(function(message){
        var bareJid = _private.jidWithoutResource(message.from),
            conv,
            tmpMessage;

        if (message.type !== 2 /*QXmppMessage.Chat*/) {
            return;
        }

        //INFO Debug purposes
        console.log('[Conversation] MessageReceived', JSON.stringify(message));
        conv = create(bareJid);
        tmpMessage = _private.wrapMessage(message);
        conv.receiveMessage(bareJid, tmpMessage);
    });

    _jabber.mucManager.messageReceived.connect(function (roomJid, message) {
        if (message.type !== 3 /*QXmppMessage.GroupChat*/) {
            return;
        }

        if (!message.body || message.subject) {
            return;
        }

        var bareJid = _private.jidWithoutResource(message.from),
            conv;

        if (message.from === bareJid) {
            return;
        }

        var from =_private.jidWithoutResource(_jabber.mucManager.participantFullJid(roomJid, message.from));
        if (!from) {
            // Cast room@server/nickname to nickname@server - nickname is UserId
            from = _private.chatFullJidToUser(message.from);
        }

        var tmpMessage = {
            to: roomJid,
            from: from,
            type: message.type,
            body: message.body,
            stamp: message.stamp,
        }

        //INFO Debug purposes
        //console.log('[Conversation] MessageReceived', JSON.stringify(message));
        conv = create(roomJid);
        if (conv.receiveMessage(from, tmpMessage)) {
            var read = (conv.readDate > tmpMessage.stamp);
            if (!read) {
                _jabber.newGroupMessageReceived(roomJid, tmpMessage);
            }
        }

    });

    messenger.messageRead.connect(function(jid) {
        var conv = create(jid);
        conv.readDate = Date.now();
    });
}

function setHistorySaveInterval(value) {
    ConversationStorage.setHistorySaveInterval(_private.getHistorySaveDuration(value));
}

function clearHistory(jid, group) {
    ConversationStorage.clear(jid, group);

    if (!_ref)
        return;

    if (jid) {
        var conversation = create(jid);
        conversation.clearMessages();
    } else {
        _ref.keys().forEach(function(jid) {
            var conversation = create(jid);
            conversation.clearMessages();
        });
    }
}

function isGroupJid(jid) {
    return jid.indexOf(_jabber.conferenceUrl()) !== -1;
}

function create(id) {
    if (!_ref)
        return;

    if (!_ref.contains(id)) {
        var type = isGroupJid(id) ? 3 : 2 // QXmppMessage.GroupChat || QXmppMessage.Chat
        _ref.append(createConversationModel(id, type));
    }

    return new Conversation(_ref.getById(id), _ref, _jabber, _jid);
}
