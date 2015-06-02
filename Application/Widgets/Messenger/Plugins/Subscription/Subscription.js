var subscriptonQueue = [];

function init(jabber, messenger, private) {
    var isDebug = false;
    function debug() {
        if (isDebug) {
            console.log.apply(console, arguments);
        }
    }

    var rosterManager = jabber.rosterManager;

    function processSubcribe(bareJid, reason) {
        debug('[Subscription] processSubcribe ', bareJid, reason);
        var conversation = messenger.getConversation(bareJid);
        var user = messenger.getUser(bareJid);

        if (user.subscription == QXmppRosterManager.To) {
            rosterManager.acceptSubscription(bareJid, "");
            var msg = qsTr("MESSAGE_BODY_SUBSCRIPTION_INVITE_APPROVED");
            conversation.appendMessage(bareJid, msg, Date.now(), Date.now(), "invite")
            return;
        }

        var subscriptionRequestMessage = qsTr("MESSENGER_SUBSCRIPTION_REQUEST_MESSAGE")
            .arg(reason)
            .arg('gamenet://subscription/decline')
            .arg('gamenet://subscription/accept');

        var tmpMessage = {
            to: messenger.authedUser().jid,
            from: bareJid,
            type: 2,
            body: subscriptionRequestMessage,
        }

        messenger.messageReceived(bareJid, tmpMessage.body, tmpMessage);

        conversation.appendMessage(bareJid, tmpMessage.body, Date.now(), Date.now(), "invite")

        if (private.needIncrementUnread(user)) {
            user.unreadMessageCount += 1;
            private.setUnreadMessageForUser(user.jid, user.unreadMessageCount);
        }

        private.updateUserTalkDate(user);
    }

    function clearQueue() {
        debug('[Subscription] clearQueue');
        subscriptonQueue = [];
    }

    function onRosterReceived() {
        debug('[Subscription] onRosterReceived\n', JSON.stringify(subscriptonQueue, null, 2));
        subscriptonQueue.forEach(function(e) {
            processSubcribe(e.bareJid, e.reason);
        });
    }

    function onSubscriptionReceived(bareJid, reason) {
        if (messenger.contactReceived) {
            processSubcribe(bareJid, reason);
            return;
        }

        debug('[Subscription] onSubscriptionReceived push to queue:', bareJid, reason);
        subscriptonQueue.push({
                                  bareJid: bareJid,
                                  reason: reason
                              });
    }

    jabber.rosterManager.subscriptionReceived.connect(onSubscriptionReceived);
    jabber.disconnected.connect(clearQueue);
    jabber.connected.connect(clearQueue);
    messenger.rosterReceived.connect(onRosterReceived);
}
