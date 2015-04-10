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
var conferenceUrl = 'conference.qj.gamenet.ru';

Qt.include("./Helpers/TimeHelper.js");

function createRawUser(jid, nickname) {
    var result = {
        userId: jidToUser(jid),
        jid: jidWithoutResource(jid),
        groups: [],
        nickname: nickname,
        unreadMessageCount: 0,
        statusMessage: "",
        presenceState: "",
        inputMessage: "",
        avatar: "",
        lastActivity: 0,
        isGamenet: false,
        lastTalkDate: "",
        online: false,
        playingGame: "",
        inContacts: false,
        isGroupChat: false,
        participants: [],
        __lastActivityRequested: false,
        __vCardRequested: false,
    };

    return result;
}

function createRawGroupChat(roomJid, nickname) {
    var result = {
        userId: "",
        jid: jidWithoutResource(roomJid),
        groups: [],
        nickname: nickname,
        unreadMessageCount: 0,
        statusMessage: "",
        presenceState: "",
        inputMessage: "",
        avatar: "",
        lastActivity: 0,
        isGamenet: false,
        lastTalkDate: "",
        online: false,
        playingGame: "",
        inContacts: false,
        isGroupChat: true,
        participants: [],
        __lastActivityRequested: false,
        __vCardRequested: false
    };

    return result;
}

function createGamenetUser() {
    var obj = createRawUser("", "GameNet");
    obj.jid = getGamenetUserJid();
    obj.userId = "";
    obj.presenceState = "online";
    obj.isGamenet = true;
    obj.online = true;
    return obj;
}

function getGamenetUserJid() {
    return "GameNet";
}

function User(item, model, jabber) {
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

    function warmUpVCard() {
        if (!_item.__vCardRequested) {
            _model.setPropertyById(self.jid, '__vCardRequested', true);
            jabber.vcardManager.requestVCard(self.jid);
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

    defGetSet("nickname");
    defGetSet("statusMessage");
    defGetSet("presenceState");
    defGetSet("inputMessage");
    defGetSet("unreadMessageCount");
    defGetSet("lastTalkDate");
    defGetSet("playingGame");

    defGetSet("inContacts");

    defGetter("isGamenet");

    defGetter("isGroupChat");


    this.__defineGetter__("online", function() {
        return isOnline(self.presenceState);
    });

    this.__defineGetter__("hasUnreadMessage", function() {
        return _item.unreadMessageCount > 0;
    });

    this.__defineGetter__("avatar", function() {
        warmUpVCard()

        return _item.avatar;
    });
    defSetter("avatar");

    this.__defineGetter__("lastActivity", function() {
        if (!_item.__lastActivityRequested) {
            _model.setPropertyById(self.jid, '__lastActivityRequested', true);
            var value = jabber.getLastActivity(self.jid);
            self.lastActivity = value;
        }

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

    defGetter("online");
    defGetter("isGamenet");

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
//        var result = [];
//        for (var j = 0; j < _item.groups.count; j++) {
//            result.push(_item.participants.get(j).name);
//        }
//        return result;

        return _item.participants;
    });

    this.__defineSetter__("participants", function(val) {
        _item.participants.clear();
        val.forEach(function (g) {
            _item.participants.append(g);
        });
    });

    this.isValid = function() {
        return !!_item && !!_model;
    }

    this.destroyRoom = function(reason) {
        jabber.mucManager.destroyRoom(this.jid, reason || "");
    }
}

function getGamenetUserJid() {
    return "GameNet";
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

function isGroupJid(jid) {
    return jid.indexOf(conferenceUrl) !== -1;
}
