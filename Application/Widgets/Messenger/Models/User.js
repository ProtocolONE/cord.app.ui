.pragma library

var serverUrl;

function conferenceUrl() {
    return "conference." + serverUrl;
}

Qt.include("./Helpers/TimeHelper.js");

function createRawUser(jid, nickname) {
    var result = {
        userId: jidToUser(jid),
        jid: jidWithoutResource(jid),
        groups: [],
        nickname: "",
        vcardNickname: "",
        rosterNickname: nickname,
        externalNickname: "",
        unreadMessageCount: 0,
        statusMessage: "",
        presenceState: "",
        inputMessage: "",
        avatar: "",
        lastActivity: 0,
        lastTalkDate: 0,
        online: false,
        playingGame: "",
        inContacts: false,
        isGroupChat: false,
        subscription: 0
    };

    return result;
}

function createRawGroupChat(roomJid, nickname) {
    var result = {
        userId: "",
        jid: jidWithoutResource(roomJid),
        groups: [],
        nickname: "",
        vcardNickname: "",
        rosterNickname: nickname,
        externalNickname: "",
        unreadMessageCount: 0,
        statusMessage: "",
        presenceState: "",
        inputMessage: "",
        avatar: "",
        lastActivity: 0,
        lastTalkDate: 0,
        online: false,
        playingGame: "",
        inContacts: false,
        isGroupChat: true
    };

    return result;
}

function createProtocolOneUser() {
    var obj = createRawUser("", "ProtocolOne");
    obj.jid = getProtocolOneUserJid();
    obj.userId = "";
    obj.presenceState = "online";
    obj.online = true;
    return obj;
}

function getProtocolOneUserJid() {
    return "ProtocolOne";
}

function User(item, model, jabber) {
    var _item = item,
        _model = model,
        self = this,
        message;

    var defGetter = function(field) {
        self.__defineGetter__(field, function() {
            if (!_item) {
                throw new Error("Can't get " + field + " of user.");
            }

            return _item[field];
        });
    }

    var defSetter = function(field) {
        self.__defineSetter__(field, function(value) {
             model.setPropertyById(self.jid, field, value);
        });
    }

    var defGetSet = function(field) {
        defGetter(field);
        defSetter(field);
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

    this.__defineGetter__("nickname", function() {
        jabber.requestVCardAsync(_item.jid);
        return _item.nickname;
    });

    this.__defineSetter__("nickname", function(value) {
        throw new Error("Nickname is read only property");
    });

    defGetSet("statusMessage");
    defGetSet("presenceState");
    defGetSet("inputMessage");
    defGetSet("unreadMessageCount");
    defGetSet("lastTalkDate");
    defGetSet("playingGame");
    defGetSet("inContacts");

    defGetter("isGroupChat");

    defGetSet("subscription");
    defGetSet("vcardNickname");
    defGetSet("rosterNickname");
    defGetSet("externalNickname");

    this.__defineGetter__("online", function() {
        return isOnline(self.presenceState);
    });

    this.__defineGetter__("hasUnreadMessage", function() {
        return _item.unreadMessageCount > 0;
    });

    this.__defineGetter__("avatar", function() {
        jabber.requestVCardAsync(_item.jid);
        return _item.avatar;
    });
    defSetter("avatar");

    this.__defineGetter__("lastActivity", function() {
        jabber.requestLastActivityAsync(self.jid);
        return _item.lastActivity;
    });
    defSetter("lastActivity");

    this.__defineGetter__("isProtocolOneMember", function() {
        _model.updatePropertyRequest(_item.jid, "isProtocolOneMember");
        return _item.isProtocolOneMember;
    });
    defSetter("isProtocolOneMember");

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
            _item.groups.append({name: g});
        });
    });

    this.isValid = function() {
        return !!_item && !!_model;
    }
}

function GroupChat(item, model, jabber) {
    var _item = item,
        _model = model,
        self = this,
        message;

    var defGetter = function(field) {
        self.__defineGetter__(field, function() {
            return _item[field];
        });
    }

    var defSetter = function(field) {
        self.__defineSetter__(field, function(value) {
             model.setPropertyById(self.jid, field, value);
        });
    }

    var defGetSet = function(field) {
        defGetter(field);
        defSetter(field);
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

    defGetSet("nickname");
    defGetSet("statusMessage");
    defGetSet("presenceState");
    defGetSet("inputMessage");
    defGetSet("unreadMessageCount");
    defGetSet("lastTalkDate");
    defGetSet("playingGame");
    defGetSet("inContacts");
    defGetSet("vcardNickname");
    defGetSet("rosterNickname");
    defGetSet("externalNickname");

    this.__defineGetter__("online", function() {
        return isOnline(self.presenceState);
    });

    defGetter("isGroupChat");

    this.__defineGetter__("hasUnreadMessage", function() {
        return _item.unreadMessageCount > 0;
    });

    this.__defineGetter__("avatar", function() {
        return _item.avatar;
    });
    defSetter("avatar");

    this.__defineGetter__("lastActivity", function() {
        return _item.lastActivity;
    });
    defSetter("lastActivity");

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
            _item.groups.append({name: g});
        });
    });


    this.__defineGetter__("participants", function() {
        return _item.participants();
    });

    this.isValid = function() {
        return !!_item && !!_model;
    }

    this.destroyRoom = function(reason) {
        jabber.mucManager.destroyRoom(this.jid, reason || "");
    }
}

function getProtocolOneUserJid() {
    return "ProtocolOne";
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

function isProtocolOne(item) {
    if (!item) {
        return false;
    }

    return item.jid === getProtocolOneUserJid();
}

function userIdToJid(userId) {
    return userId + '@' + serverUrl;
}

function isGroupJid(jid) {
    return jid.indexOf(conferenceUrl()) !== -1;
}
