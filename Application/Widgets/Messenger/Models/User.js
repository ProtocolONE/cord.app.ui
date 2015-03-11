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
var serverUrl;

Qt.include("Message.js");

function subtractTime(date, num, name) {
    var tmp = new Date(date),
        map = {
            'week': 604800000,
            'day': 86400000,
            'hour': 3600000,
            'minute': 60000,
            'seconds': 1000,
        };

    if (name == 'month') {
        tmp.setMonth(tmp.getMonth() - num);
    } else {
        tmp.setTime(tmp.getTime() - map[name] * num);
    }

    return +tmp;
}

function User(item, model, jabber) {
    var _item = item,
        _model = model,
        self = this,
        message;

    function warmUpVCard() {
        if (!_item.__vCardRequested) {
            jabber.vcardManager.requestVCard(self.jid);
            _model.setPropertyById(self.jid, '__vCardRequested', true);
        }
    }

    this.__defineGetter__("jid", function() {
        if (!_item) {
            return "";
        }

        return _item.jid;
    });

    this.__defineGetter__("userId", function() {
        return jidToUser(_item.jid);
    });

    this.__defineGetter__("messages", function() {
        if (!_item.__historyRequested) {
            _model.setPropertyById(self.jid, '__historyRequested', true);
            jabber.queryHistory(self.jid, undefined, undefined, _item.messages);
        }

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

    this.__defineGetter__("avatar", function() {
        warmUpVCard()

        return _item.avatar;
    });

    this.__defineSetter__("avatar", function(val) {
        _model.setPropertyById(self.jid, 'avatar', val);
    });

    this.__defineGetter__("lastActivity", function() {
        if (!_item.__lastActivityRequested) {
            _model.setPropertyById(self.jid, '__lastActivityRequested', true);
            var value = jabber.getLastActivity(self.jid);
            self.lastActivity = value;
        }

        return _item.lastActivity;
    });

    this.__defineSetter__("lastActivity", function(val) {
        _model.setPropertyById(self.jid, 'lastActivity', val);
    });

    this.__defineGetter__("isGamenet", function() {
        return _item.isGamenet;
    });

    this.__defineGetter__("historyDay", function() {
        return _item.historyDay;
    });

    this.__defineGetter__("lastTalkDate", function() {
        return _item.lastTalkDate;
    });

    this.__defineSetter__("historyDay", function(val) {
        _model.setPropertyById(self.jid, 'historyDay', val);
    });

    this.__defineSetter__("lastTalkDate", function(val) {
        _model.setPropertyById(self.jid, 'lastTalkDate', val);
    });

    this.__defineGetter__("online", function() {
        return isOnline(self.presenceState);
    });

    this.__defineGetter__("playingGame", function() {
        return _item.playingGame;
    });

    this.__defineSetter__("playingGame", function(val) {
        _model.setPropertyById(self.jid, 'playingGame', val);
    });

    this.__defineGetter__("groups", function() {
        var result = [];
        for (var j = 0; j < _item.groups.count; j++) {
            result.push(_item.groups.get(j).name);
        }

        return result;
    });

    this.__defineSetter__("groups", function(val) {
        _item.groups.clear();
        val.forEach(function (g) {
            _item.groups.append({
                                    name: g
                                });
        });
    });

    this.isValid = function() {
        return !!_item && !!_model;
    }

    this.appendRawMessage = function(from, isStatus, body, date) {
        message = createRawMessage(from, isStatus, body, date);
        _item.messages.append(message);
    }

    this.appendMessage = function(from, body, date) {
        if (self.jid !== from) {
            if (self.isLastMessageStatus) {
                message = createRawMessage(from, false, body, date)
                _item.messages.insert(_item.messages.count - 1, message);
            } else {
                self.appendRawMessage(from, false, body, date);
            }

            return;
        }

        if (self.isLastMessageStatus) {
            self.lastMessage.finishComposing(body, date);
            _item.state = MessageType.Normal;
            return;
        }

        self.appendRawMessage(from, false, body, date);
    }

    this.prependMessage = function(from, body, date) {
        message = createRawMessage(from, false, body, date);
        _item.messages.insert(0, message);
    }

    this.mergeMessage = function(from, body, date) {
        var foundIndex,
            msg,
            i;

        message = createRawMessage(from, false, body, date);

        foundIndex = _item.messages.count;
        for (i = 0; i < _item.messages.count; i++) {
            msg = _item.messages.get(i);
            if (date < msg.date) {
                foundIndex = i;
                break;
            }
        };

        _item.messages.insert(foundIndex, message);
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

    this.queryMoreMessages = function(num, name) {
        if (!_item.__historyRequested) {
            _model.setPropertyById(self.jid, '__historyRequested', true);
            jabber.queryHistory(self.jid, undefined, undefined, _item.messages);
        }

        if (!self.historyDay) {
            self.historyDay = startOfDay();
        }

        var from = subtractTime(startOfDay(self.historyDay), num, name);

        jabber.queryHistory(self.jid, from, self.historyDay, _item.messages);
        self.historyDay = from;
    }
}

function createRawUser(jid, nickname) {
    var result = {
        userId: jidToUser(jid),
        jid: jidWithoutResource(jid),
        groups: [],
        nickname: nickname,
        unreadMessageCount: 0,
        state: 0,
        messages: [],
        statusMessage: "",
        presenceState: "",
        inputMessage: "",
        avatar: "",
        lastActivity: 0,
        historyDay: startOfDay(),
        isGamenet: false,
        lastTalkDate: "",
        online: false,
        playingGame: "",
        inContacts: false,
        __lastActivityRequested: false,
        __vCardRequested: false,
        __historyRequested: false
    };

    return result;
}

function getGamenetUserJid() {
    return "GameNet";
}

function createGamenetUser() {
    var result = {
        userId: "",
        jid: getGamenetUserJid(),
        nickname: "GameNet",
        unreadMessageCount: 0,
        state: 0,
        messages: [],
        groups: [],
        statusMessage: "",
        presenceState: "online",
        inputMessage: "",
        avatar: "",
        lastActivity: 0,
        historyDay: startOfDay(),
        isGamenet: true,
        lastTalkDate: "",
        online: true,
        playingGame: "",
        inContacts: false,
        __lastActivityRequested: false,
        __vCardRequested: false
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

function isOnline(status) {
    switch(status) {
    case "online":
    case "chat":
    case "dnd":
    case "away":
    case "xa":
        return true;
    case "offline":
    default:
        return false;
    }
}

function isGameNet(item) {
    if (!item) {
        return false;
    }

    return item.jid === getGamenetUserJid();
}

function userIdToJid(userId) {
    return userId + '@' + serverUrl;
}
