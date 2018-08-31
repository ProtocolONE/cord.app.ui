pragma Singleton

import QtQuick 2.0
import QXmpp 1.0

import Application.Widgets.Messenger.Models.Managers 1.0
import "./Subscription.js" as Js

Item {
    function init(jabber, messenger, privateObj) {
        var isDebug = false;

        function debug() {
            if (isDebug) {
                console.log.apply(console, arguments);
            }
        }

        var rosterManager = jabber.rosterManager;

        function processSubcribe(bareJid, reason) {
            debug('[Subscription] processSubcribe ', bareJid, reason);
            var conversation = messenger.getConversation(bareJid)
                , user
                , subscription = jabber.rosterManager.getSubscription(bareJid);

            if (subscription == QXmppRosterManager.To) {
                rosterManager.acceptSubscription(bareJid, "");
                var msg = qsTr("MESSAGE_BODY_SUBSCRIPTION_INVITE_APPROVED");
                conversation.appendMessage(bareJid, msg, Date.now(), Date.now(), "invite")
                return;
            }

            var subscriptionRequestMessage = qsTr("MESSENGER_SUBSCRIPTION_REQUEST_MESSAGE")
                .arg(reason)
                .arg('protocolone://subscription/decline')
                .arg('protocolone://subscription/accept');

            var tmpMessage = {
                to: messenger.authedUser().jid,
                from: bareJid,
                type: 2,
                body: subscriptionRequestMessage,
            }

            messenger.messageReceived(bareJid, tmpMessage.body, tmpMessage);

            conversation.appendMessage(bareJid, tmpMessage.body, Date.now(), Date.now(), "invite")

            user = messenger.getUser(bareJid);
            if (privateObj.needIncrementUnread(user)) {
                user.unreadMessageCount += 1;
                privateObj.setUnreadMessageForUser(user.jid, user.unreadMessageCount);
            }

            RecentConversations.updateUserTalkDate(user);
        }

        function clearQueue() {
            debug('[Subscription] clearQueue');
            Js.subscriptonQueue = [];
        }

        function onRosterReceived() {
            debug('[Subscription] onRosterReceived\n', JSON.stringify(Js.subscriptonQueue, null, 2));
            Js.subscriptonQueue.forEach(function(e) {
                processSubcribe(e.bareJid, e.reason);
            });
        }

        function onSubscriptionReceived(bareJid, reason) {
            if (messenger.contactReceived) {
                processSubcribe(bareJid, reason);
                return;
            }

            debug('[Subscription] onSubscriptionReceived push to queue:', bareJid, reason);
            Js.subscriptonQueue.push({
                                      bareJid: bareJid,
                                      reason: reason
                                  });
        }

        jabber.rosterManager.subscriptionReceived.connect(onSubscriptionReceived);
        jabber.disconnected.connect(clearQueue);
        jabber.connected.connect(clearQueue);
        messenger.rosterReceived.connect(onRosterReceived);
    }
}

