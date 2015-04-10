.pragma library

Qt.include("../../Models/User.js");

var bookmarks = null;

function init(jabber, messenger) {
    bookmarks = new Bookmarks(jabber, messenger);
}

var Bookmarks = function(jabber, messenger) {
    var self = this,
        queue = [],
        isReceived = false,
        bookmarks,
        knownConferences = {};

    this.conference = function() {
        if (!bookmarks || !bookmarks.conferences) {
            return [];
        }

        var res = bookmarks.conferences.reduce(
                    function(acc, c) {
                        acc.push(c.jid);
                        return acc;
                    }
                    , []);

        return res;
    }

    this.addConference = function(roomJid) {
        if (!isReceived) {
            queue.push(roomJid);
            return;
        }

        if (insertConference(roomJid)) {
            sendBookmarks();
        }
    }

    this.removeConference = function(roomJid) {
        if (!isReceived || !containsConference(roomJid)) {
            return;
        }

        var index = -1;
        for (var i = 0; i < bookmarks.conferences.length; ++i) {
            if (bookmarks.conferences[i].jid === roomJid) {
                index = i;
            }
        }

        if (index != -1) {
            bookmarks.conferences.splice(index, 1);
            sendBookmarks();
        }
    }

    function reset() {
        isReceived = false;
        queue = [];
        bookmarks = null;
        knownConferences = {};
    }

    function sendBookmarks() {
        jabber.bookmarkManager.setBookmarks(bookmarks);
    }

    function insertConference(roomJid) {
        if (containsConference(roomJid)) {
            return false;
        }

        knownConferences[roomJid] = 1;
        bookmarks.conferences.push({
                                     autojoin: true,
                                     jid: roomJid
                                   });
        return true;
    }

    function setKnownConferences() {
        if (bookmarks.conferences) {
            bookmarks.conferences.forEach(function(c) {
                knownConferences[c.jid] = 1;
            });
        }
    }

    function containsConference(roomJid) {
        return knownConferences.hasOwnProperty(roomJid);
    }

    function processQueue() {
        var shouldResend = false;
        if (queue.length === 0) {
            return;
        }

        queue.forEach(function(r) {
           shouldResend = insertConference(r) || shouldResend;
        });

        if (shouldResend) {
          sendBookmarks();
        }
    }

    function bookmarksReceived(bookmarksReceived) {
        if (isReceived) { // let's process only first response
            return;
        }

        console.log('jabber.bookmarkManager.received', JSON.stringify(bookmarksReceived))

        isReceived = true;
        bookmarks = bookmarksReceived;
        if (!bookmarks.conferences) {
            bookmarks.conferences = [];
        }

        setKnownConferences();
        processQueue();

        jabber.bookmarksReceived(bookmarks);
    }

    function onInviteReceived(roomJid, inviter, reason) {
        self.addConference(roomJid);
    }

    function onRoomJoined(roomJid) {
        console.log('[Bookmarks] Joined ', roomJid)
        self.addConference(roomJid);
    }

    function onParticipantPermissions(roomJid, jid, permissions) {
        var occupantJid = jidWithoutResource(permissions.jid);
        if (messenger.authedUser().jid !== occupantJid) {
            return;
        }

        if (permissions.affiliation === "none" || permissions.affiliation === "outcast") {
            self.removeConference(roomJid);
        }
    }

    jabber.bookmarkManager.received.connect(bookmarksReceived);
    jabber.disconnected.connect(reset);

    jabber.mucManager.invitationReceived.connect(onInviteReceived);
    jabber.mucManager.joined.connect(onRoomJoined);
    jabber.mucManager.participantPermissions.connect(onParticipantPermissions);
}
