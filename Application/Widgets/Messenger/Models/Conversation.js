Qt.include("./Message.js");

function createConversationModel(id, type) {
    return {
        id: id,
        type: type,
        messages: [],
        state: 0,
        author: '',
        historyDay: 0,
        readDate: 0,
        __queryMessage: false,
        __queryReadDate: false,
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

    defGetSet('type')
    defGetSet('historyDay')
    defGetSet('state')
    defGetSet('__queryMessage');
    defGetSet('__queryReadDate');

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

    this.__defineGetter__("readDate", function() {
        var readDate;
        if (self.__queryReadDate === false) {
            self.__queryReadDate = true;
            try {
                readDate = ConversationStorage.queryReadDate(this.id);
                model.setPropertyById(item.id, 'readDate', readDate);
                return readDate;
            } catch(e) {
            }
        }

        return item.readDate;
    });

    this.__defineSetter__("readDate", function(value) {
        if (self.readDate !== value) {
            model.setPropertyById(item.id, 'readDate', value);
            ConversationStorage.saveReadDate(this.id, value);
        }
    });
    this.setTypingState = function(value) {
        if (this.type == 2) {
            jabber.sendInputStatus(this.id, value);
        }
    }

    this.writeMessage = function(body) {
        if (body && body[0] === '/') {
            jabber.chatCommand(this.id, body);
            return;
        }

        var message = {
            body: body,
            from: _jid,
            type: this.type, //QXmppMessage.Chat or QXmppMessage.GroupChat
            state: 1 //QXmppMessage.Active
        };

        var time = Date.now();

        if (this.type == 2) { // QXmppMessage.Chat
            var id = ConversationStorage.save(this.id, message);
            delete message.from;
            this.appendMessage(_jid, message.body, time, id);
        }

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
            hasStamp = (message.stamp != "Invalid Date"),
            newMessage = false;

        if (!message.body) {
            this.changeState(fromJid, message.state);
            return newMessage;
        }

        if (!hasStamp) {
            date = Date.now();
            message.stamp = date;
        } else {
            date = message.stamp;
        }

        if (this.type === 3 && !hasStamp) {
            this.appendMessage(fromJid, message.body, date, id);
            newMessage = true;
        } else {
            try {
                id = ConversationStorage.save(this.id, message);
                this.appendMessage(fromJid, message.body, date, id);
                newMessage = true;
            } catch(e) {
            }
        }

        if (hasStamp) {
            this.query(message.stamp, date/1000|0);
        }

        return newMessage
    }

    this.appendMessage = function(from, body, date, id, type) {
        if (this.id !== from) {
            if (this.isLastMessageStatus) {
               var message = createRawMessage(from, false, body, date, id, type)
               item.messages.insert(item.messages.count - 1, message);
            } else {
               this.appendRawMessage(from, false, body, date, id, type);
            }
            return;
        }

        if (this.isLastMessageStatus) {
            this.lastMessage.finishComposing(body, date, id);
            item.state = MessageType.Normal;
            return;
        }

        this.appendRawMessage(from, false, body, date, id, type);
    }

    this.appendRawMessage = function(from, isStatus, body, date, id, type) {
        var message = createRawMessage(from, isStatus, body, date, id, type);
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
