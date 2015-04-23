function init(jabber, messenger) {
    jabber.mucManager.invitationReceived.connect(function (roomJid, inviter, reason) {
        jabber.joinRoom(roomJid)
    });

    jabber.bookmarksReceived.connect(function(bookmarks) {
        bookmarks.conferences.forEach(function(conference) {
            jabber.joinRoom(conference.jid)
        })
    });
}
