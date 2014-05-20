var MessageState = function() {};
MessageState.None = 0;   ///< The message does not contain any chat state information.
MessageState.Active = 1;     ///< User is actively participating in the chat session.
MessageState.Inactive = 2;   ///< User has not been actively participating in the chat session.
MessageState.Gone = 3;       ///< User has effectively ended their participation in the chat session.
MessageState.Composing = 4;  ///< User is composing a message.
MessageState.Paused = 5;     ///< User had been composing but now has stopped.

var MessageType = function() {};
MessageType.Error = 0;
MessageType.Normal = 1;
MessageType.Chat = 2;
MessageType.GroupChat = 3;
MessageType.Headline = 4;

function Message(model, index) {
    var _item = model.get(index),
        _model = model,
        _index = index;

    this.__defineGetter__("index", function() {
        return _index;
    });

    this.__defineGetter__("jid", function() {
        return _item.jid;
    });

    this.__defineSetter__("jid", function(val) {
        _model.setProperty(_index, 'jid', val);
    });

    this.__defineGetter__("isStatusMessage", function() {
        return _item.isStatusMessage;
    });

    this.__defineSetter__("isStatusMessage", function(val) {
        _model.setProperty(_index, 'isStatusMessage', val);
    });

    this.__defineGetter__("text", function() {
        return _item.text;
    });

    this.__defineSetter__("text", function(val) {
        _model.setProperty(_index, 'text', val);
    });

    this.__defineGetter__("date", function() {
        return _item.date;
    });

    this.__defineSetter__("date", function(val) {
        _model.setProperty(_index, 'date', val);
    });

    this.finishComposing = function(body) {
        this.isStatusMessage = false;
        this.date = +(new Date());
        this.text = body;
    }
}

function createRawMessage(from, isStatus, body) {
    var result = {
        jid: from,
        text: body || "",
        date: (+ new Date()),
        isStatusMessage: isStatus
    };

    return result;
}

function stateMessage(state) {
    var result = "";
    if (state === MessageState.Composing) {
        result = qsTr("MESSAGE_STATE_COMPOSING");
    }

    if (state === MessageState.Paused) {
        result = qsTr("MESSAGE_STATE_PAUSED");
    }

    if (state === MessageState.Inactive) {
        result = qsTr("MESSAGE_STATE_INACTIVE");
    }

    return result;
}

function canShowState(state) {
    var result = (state === MessageState.Composing)
        || (state === MessageState.Paused)
        || (state === MessageState.Inactive);

    return result;
}
