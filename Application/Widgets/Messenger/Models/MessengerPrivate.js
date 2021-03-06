.pragma library

// INFO see Messenger.js
var USER_INFO_FULL = 1;
var USER_INFO_JID = 2;

var DISCONNECTED     = 0;
var CONNECTING       = 1;
var ROSTER_RECEIVING = 2;
var ROSTER_RECEIVED  = 3;
var RECONNECTING     = 4;

var lastTalkDateMap = {}
    , unreadMessageCountMap;

function InsertUsersToModel(opt) {
    var self = this;

    this.cb = opt.cb;
    this.finish = opt.finish;

    this.index = opt.index || 0;
    this.currentIndex = this.index;
    this.users = opt.users || [];

    this.execute = function() {
        var i,
            batchSize,
            users,
            item;

        batchSize = 100;

        users = this.users.slice(0, batchSize);
        users.forEach(function(user) {
            self.cb(user, self.users.length);
            self.currentIndex++;
        });

        this.users.splice(0, batchSize);
        if (this.users.length === 0) {
            if (self.finish) {
                self.finish();
            }
        }

        return this.users.length === 0;
    }
}


function ClearUsersModel(opt) {
    this.execute = function() {
        opt.model.clear();
        opt.model.endBatch();
        return true;
    }
}

function RequestVcard(opt) {
    this.uniqueId = "RequestVcard" + opt.jid;
    this.execute = function() {
        if (opt.messenger.connected) {
            opt.jabber.requestVcard(opt.jid);
        }
        return true;
    }
}

function RequestLastActivity(opt) {
    this.uniqueId = "RequestLastActivity" + opt.jid;
    this.execute = function() {
        if (opt.messenger.connected) {
            opt.jabber.getLastActivity(opt.jid, opt.force);
        }
        return true;
    }
}

function MarkAllMessagesRead(opt) {
    this.execute = function() {
        var batchSize = 100;
        var users = opt.users.slice(0, batchSize);
        users.forEach(function(user) {
            opt.callback(user);
        });

        opt.users.splice(0, batchSize);
        return opt.users.length === 0;
    }
}

var shortInfoQueue = {};
