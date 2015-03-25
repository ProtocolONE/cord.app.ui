Qt.include("./Message.js");

function createConversationModel(id) {
    return {
        id: id,
        messages: [],
        state: 0,
        author: '',
        __queryMessage: false,
    }
}

var Conversation = function(item, model, jabber, myJid) {
    var self = this;

    var defGetter = function(field) {
        self.__defineGetter__(field, function() {
            return item[field];
        });
    }

    var defSetter = function(field) {
        self.__defineSetter__(field, function(value) {
            model.setPropertyById(item.id, field, value);
        });
    }

    var defGetSet = function(field) {
        defGetter(field);
        defSetter(field);
    }

    defGetter('id')
    defGetter('author')

    defGetSet('historyDay')
    defGetSet('state')
    defGetSet('__queryMessage');

    this.__defineGetter__("isLastMessageStatus", function() {
        if (item.messages.count <= 0) {
            return false;
        }

        var message = new Message(item.messages, item.messages.count - 1);
        return message.isStatusMessage;
    });

    this.__defineGetter__("lastMessage", function() {
        if (item.messages.count <= 0) {
            throw new Error('Could not get last message.')
        }

        return new Message(item.messages, item.messages.count - 1);
    });

    this.__defineGetter__('messages', function() {
        if (self.__queryMessage === false) {
            self.__queryMessage = true;

            var lastMessageDate = ConversationStorage.queryLastMessageDate(this.id);
            var from = (startOfDay(lastMessageDate * 1000)/1000|0) - 86400;

            this.query(from, lastMessageDate);
        }

        return item.messages;
    });

    this.setTypingState = function(value) {
        jabber.sendInputStatus(this.id, value);
    }

    this.writeMessage = function(body) {
        var message = {
            body: body,
            from: _jid,
            type: 2, //QXmppMessage.Chat
            state: 1 //QXmppMessage.Active
        };

        var time = Date.now();

        var id = ConversationStorage.save(this.id, message);
        delete message.from;

        this.appendMessage(_jid, message.body, time, id);

        jabber.sendMessageEx(this.id, message);
    }

    this.queryLast = function(number, name) {
        if (!this.historyDay) {
            this.historyDay = startOfDay();
        }

        var from = subtractTime(startOfDay(this.historyDay), number, name);

        this.query(from, this.historyDay);
        this.historyDay = from;
    };

    this.query = function(from, to) {
        var data = ConversationStorage.query(this.id, from, to);
        var existingMessages = {};

        for (var i = 0; i < item.messages.count; i++ ) {
            existingMessages[item.messages.get(i).id] = 1;
        }

        data.filter(function(e) {
            return !existingMessages.hasOwnProperty(e.id);
        }).map(function(e) {
            var msg = createRawMessage(e.fromJid, false, e.body, e.timestamp * 1000, e.id);
            var foundIndex = item.messages.count;

            for (i = 0; i < item.messages.count; i++) {
                var tmp = item.messages.get(i);
                if (e.timestamp < tmp.date) {
                    foundIndex = i;
                    break;
                }
            };
            item.messages.insert(foundIndex, msg);
        });
    };

    this.receiveMessage = function(fromJid, message) {
        var id,
            date,
            hasStamp = (message.stamp != "Invalid Date");

        if (!message.body) {
            this.changeState(fromJid, message.state);
            return;
        }

        if (!hasStamp) {
            date = Date.now();
        } else {
            date = message.stamp;
        }

        id = ConversationStorage.save(this.id, message);
        this.appendMessage(fromJid, message.body, date, id);

        if (hasStamp) {
            this.query(message.stamp, date/1000|0);
        }
    }

    this.appendMessage = function(from, body, date, id) {
        if (this.id !== from) {
            if (this.isLastMessageStatus) {
               var message = createRawMessage(from, false, body, date, id)
               item.messages.insert(item.messages.count - 1, message);
            } else {
               this.appendRawMessage(from, false, body, date, id);
            }
            return;
        }

        if (this.isLastMessageStatus) {
            this.lastMessage.finishComposing(body, date);
            item.state = MessageType.Normal;
            return;
        }

        this.appendRawMessage(from, false, body, date, id);
    }

    this.appendRawMessage = function(from, isStatus, body, date, id) {
        var message = createRawMessage(from, isStatus, body, date, id);
        item.messages.append(message);
    }

    this.removeMessage = function(msg) {
        item.messages.remove(msg.index);
    }

    this.changeState = function(from, state) {
        this.state = state;

        if (this.isLastMessageStatus) {
            if (canShowState(state)) {
                this.lastMessage.text = stateMessage(state);
            } else {
                this.removeMessage(this.lastMessage);
            }
        } else {
            if (canShowState(state)) {
                this.appendRawMessage(from, true, stateMessage(state));
            }
        }
    }
}
