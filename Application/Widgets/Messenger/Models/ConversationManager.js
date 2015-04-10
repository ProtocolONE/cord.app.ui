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
    }
};

function init(jabber, extendedListModel) {
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
        console.log('[Conversation] Init Conversation manager for ', _jabber.myJid);

        _jid = _jabber.myJid;
        _db = _modelInstance.getDb(_jid);

        ConversationStorage.init(_db);
    });

     _jabber.carbonMessageReceived.connect(function(message) {
         var bareJid = _private.jidWithoutResource(message.from),
             conv;

         if (message.type !== 2 /*QXmppMessage.Chat*/ || !message.body) {
             return;
         }

         //INFO Debug purposes
         //console.log('[Conversation] CarbonMessageReceived', JSON.stringify(message));
         conv = create(bareJid);
         conv.receiveMessage(bareJid, message);
     });

    _jabber.messageReceived.connect(function(message) {
        var bareJid = _private.jidWithoutResource(message.from),
            conv;

        if (message.type !== 2 /*QXmppMessage.Chat*/) {
            return;
        }

        //INFO Debug purposes
        //console.log('[Conversation] MessageReceived', JSON.stringify(message));
        conv = create(bareJid);
        conv.receiveMessage(bareJid, message);
    });

    _jabber.mucManager.messageReceived.connect(function (roomJid, message) {
        if (message.type !== 3 /*QXmppMessage.GroupChat*/) {
            return;
        }

        if (!message.body) {
            return;
        }

        var bareJid = _private.jidWithoutResource(message.from),
            conv;

        if (message.from === bareJid) {
            return;
        }

        var from =_private.jidWithoutResource(_jabber.mucManager.participantFullJid(roomJid, message.from));
        console.log('--- room message ', message.from, from, '\n', JSON.stringify(message, null, 2));
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
        conv.receiveMessage(from, tmpMessage);
    });
}

function setHistorySaveInterval(value) {
    ConversationStorage.setHistorySaveInterval(_private.getHistorySaveDuration(value));
}

function clearHistory() {
    ConversationStorage.clear();
}

function create(id) {
    if (!_ref.contains(id)){
        _ref.append(createConversationModel(id));
    }

    return new Conversation(_ref.getById(id), _ref, _jabber, _jid);
}
