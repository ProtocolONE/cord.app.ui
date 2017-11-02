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

function stateMessage(state) {
    var result = "";
    if (state === MessageState.Composing) {
        result = qsTranslate("Conversation", "MESSAGE_STATE_COMPOSING");
    }

    if (state === MessageState.Paused) {
        result = qsTranslate("Conversation", "MESSAGE_STATE_PAUSED");
    }

    if (state === MessageState.Inactive) {
        result = qsTranslate("Conversation", "MESSAGE_STATE_INACTIVE");
    }

    return result;
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

    this.writeMessage = function(body, mesId) {
        if (body && body[0] === '/') {
            jabber.chatCommand(this.id, body);
            return;
        }

        var message = {
            body: body,
            from: _jid,
            type: this.type, //QXmppMessage.Chat or QXmppMessage.GroupChat
            state: 1, //QXmppMessage.Active
            messageId: ""
        };

        if (mesId !== "")
            message["replaceId"] = mesId;

        var time = Date.now();

        // Sending

        message.messageId = jabber.sendMessageEx(this.id, message);

        // Save/Update model & history

        if (this.type == 2) { // QXmppMessage.Chat

            if (mesId === "") {
                var id = ConversationStorage.save(this.id, message);
                delete message.from;
                this.appendMessage(_jid, message.body, time, id, null, message.messageId);
            } else {
                this.updateModel(mesId, message.messageId, message.body);
                ConversationStorage.updateMessage(mesId, message.messageId, message.body);
            }
        }         
    }

    this.queryLast = function(number, name) {
        if (!this.historyDay) {
            this.historyDay = startOfDay();
        }

        var from = subtractTime(startOfDay(this.historyDay), number, name);

        this.query((from/1000)|0, (this.historyDay/1000)|0);
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
            var msg = createRawMessage(e.fromJid, false, e.body, e.timestamp * 1000, e.id, null, e.message_id, e.edited);
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
            date = +(message.stamp);
        }

        if (message.isReplaceMessage) {
            this.updateMessage(message);
            return;
        }

        if (this.type === 3 && !hasStamp) {
            this.appendMessage(fromJid, message.body, date, id, null, message.id);
            newMessage = true;
        } else {
            try {
                id = ConversationStorage.save(this.id, message);
                this.appendMessage(fromJid, message.body, date, id, null, message.id);
                newMessage = true;
            } catch(e) {
            }
        }

        if (hasStamp) {
            this.query(+(message.stamp), date/1000|0);
        }

        return newMessage;
    }

    this.updateModel = function(replaceId, newId, body) {

        var current = Date.now();
        var result = true;

        for (var i = item.messages.count - 1; i >= 0; i--) {
            // Check timestamp in model

            var diff = (current - item.messages.get(i).timestamp)/1000;

            if (diff <= 1800) { // 30 minutes to go
                result = false;
                break;
            }

            if (item.messages.get(i).messageId === replaceId) {
                // Edited flag
                item.messages.get(i).edited = 1;
                // Update text
                item.messages.get(i).text = body;
                // Update message id
                item.messages.get(i).messageId = newId;
                break;
            }
        }

        return result;
    }

    this.updateMessage = function(message) {
        // 1. Update model

        if (!this.updateModel(message.replaceId, message.id, message.body))
            return;

        // If timestamp is ok then updating history

        // 2. Update history

        ConversationStorage.updateMessage(message.replaceId, message.id, message.body);
    }

    this.appendMessage = function(from, body, date, id, type, qxmppId) {
        if (this.id !== from) {
            if (this.isLastMessageStatus) {
               var message = createRawMessage(from, false, body, date, id, type, qxmppId)
               item.messages.insert(item.messages.count - 1, message);
            } else {
               this.appendRawMessage(from, false, body, date, id, type, qxmppId);
            }
            return;
        }

        if (this.isLastMessageStatus) {
            this.lastMessage.finishComposing(body, date, id, qxmppId);
            item.state = MessageType.Normal;
            return;
        }

        this.appendRawMessage(from, false, body, date, id, type, qxmppId);
    }

    this.appendRawMessage = function(from, isStatus, body, date, id, type, qxmppId) {
        var message = createRawMessage(from, isStatus, body, date, id, type, qxmppId);
        item.messages.append(message);
    }

    this.removeMessage = function(msg) {
        item.messages.remove(msg.index);
    }

    this.clearMessages = function() {
        item.messages.clear();
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
