function init(jabber, messenger) {
    function join(roomJid) {
        jabber.mucManager.addRoom(roomJid);
        jabber.mucManager.join(roomJid, messenger.authedUser().userId);
    }

    jabber.mucManager.invitationReceived.connect(function (roomJid, inviter, reason) {
        join(roomJid);
    });

    jabber.bookmarksReceived.connect(function(bookmarks) {
        bookmarks.conferences.forEach(function(conference) {
            join(conference.jid);
        })
    });
}
