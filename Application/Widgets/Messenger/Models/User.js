Qt.include("Message.js");

function User(item, model) {
    var _item = item,
        _model = model,
        self = this,
        message;

    this.__defineGetter__("jid", function() {
        return _item.jid;
    });

    this.__defineGetter__("userId", function() {
        return jidToUser(_item.jid);
    });

    this.__defineGetter__("messages", function() {
        return _item.messages;
    });

    this.__defineGetter__("nickname", function() {
        return _item.nickname;
    });

    this.__defineSetter__("nickname", function(val) {
        _model.setPropertyById(self.jid, 'nickname', val);
    });

    this.__defineGetter__("unreadMessageCount", function() {
        return _item.unreadMessageCount;
    });

    this.__defineSetter__("unreadMessageCount", function(val) {
        _model.setPropertyById(self.jid, 'unreadMessageCount', val);
    });

    this.__defineGetter__("hasUnreadMessage", function() {
        return _item.unreadMessageCount > 0;
    });

    this.__defineGetter__("state", function() {
        return _item.state;
    });

    this.__defineGetter__("lastMessage", function() {
        if (_item.messages.count <= 0) {
            throw new Error('Could not get last message.')
        }

        return new Message(_item.messages, _item.messages.count - 1);
    });

    this.__defineGetter__("isLastMessageStatus", function() {
        if (_item.messages.count <= 0) {
            return false;
        }

        message = new Message(_item.messages, _item.messages.count - 1);
        return message.isStatusMessage;
    });

    this.__defineGetter__("statusMessage", function() {
        return _item.statusMessage;
    });

    this.__defineSetter__("statusMessage", function(val) {
        _model.setPropertyById(self.jid, 'statusMessage', val);
    });

    this.__defineGetter__("presenceState", function() {
        return _item.presenceState;
    });

    this.__defineSetter__("presenceState", function(val) {
        _model.setPropertyById(self.jid, 'presenceState', val);
    });

    this.__defineGetter__("inputMessage", function() {
        return _item.inputMessage;
    });

    this.__defineSetter__("inputMessage", function(val) {
        _model.setPropertyById(self.jid, 'inputMessage', val);
    });

    this.isValid = function() {
        return !!_item && !!_model;
    }

    this.appendRawMessage = function(from, isStatus, body) {
        message = createRawMessage(from, isStatus, body);
        _item.messages.append(message);
    }

    this.appendMessage = function(from, body) {
        if (self.jid !== from) {
            if (self.isLastMessageStatus) {
                message = createRawMessage(from, false, body)
                _item.messages.insert(_item.messages.count - 1, message);
            } else {
                self.appendRawMessage(from, false, body);
            }

            return;
        }

        if (self.isLastMessageStatus) {
            self.lastMessage.finishComposing(body);
            _item.state = MessageType.Normal;
            return;
        }

        self.appendRawMessage(from, false, body);
    }

    this.removeMessage = function(msg) {
        self.messages.remove(msg.index);
    }

    this.changeState = function(from, state) {
        _item.state = state;
        if (self.isLastMessageStatus) {
            if (canShowState(state)) {
                self.lastMessage.text = stateMessage(state);
            } else {
                self.removeMessage(self.lastMessage);
            }
        } else {
            if (canShowState(state)) {
                self.appendRawMessage(from, true, stateMessage(state));
            }
        }
    }
}

function createRawUser(jid, nickname) {
    var result = {
        userId: jidToUser(jid),
        jid: jidWithoutResource(jid),
        nickname: nickname,
        unreadMessageCount: 0,
        state: 0,
        messages: [],
        statusMessage: "",
        presenceState: "",
        inputMessage: ""
    };

    return result;
}

function jidToUser(jid) {
    var pos = jid.indexOf('@');
    if (pos < 0)
        return '';
    return jid.substring(0, pos);
}

function jidWithoutResource(jid) {
    var pos = jid.indexOf('/');
    if (pos < 0)
        return jid;

    return jid.substring(0, pos);
}
