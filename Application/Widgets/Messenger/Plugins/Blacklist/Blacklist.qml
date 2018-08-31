pragma Singleton

import QtQuick 2.0
import QXmpp 1.0

import ProtocolOne.Core 1.0

import Application.Widgets.Messenger.Models.Managers 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0

import "./Blacklist.js" as Js

Item {
    id: root

    property variant protocolOneBlacklist

    property variant jabber
    property variant messenger

    function init(jabber, messenger) {
        root.jabber = jabber;
        root.messenger = messenger;

        var isDebug = false;

        var self = this,
            isReceived = false;

        function debug() {
            if (isDebug) {
                console.log.apply(console, arguments);
            }
        }

        jabber.disconnected.connect(root.reset);
        messenger.rosterReceived.connect(root.beginSynchronization);

        jabber.blacklistManager.blacklistReceived.connect(root.jabberBlacklistReceived);
        jabber.blacklistManager.blocked.connect(root.jabberUserBlocked);
        jabber.blacklistManager.unblocked.connect(root.jabberUserUnblocked);
    }

    function reset() {
        Js.clear();
    }

    function beginSynchronization() {
        RestApi.User.getIgnoreList(root.getIgnoreListCallback, root.getIgnoreListCallback);
    }

    function getIgnoreListCallback(res) {
        if (!Array.isArray(res)) {
            return;
        }

        root.protocolOneBlacklist = res
            .filter(function(item) {
                return !(!item || !item.id);
            })
            .map(function (item) {
                return messenger.userIdToJid(item.id);
            });

        Js.clear();
        root.protocolOneBlacklist.forEach(function(jid) {
            Js.block(jid)
        });

        root.jabber.blacklistManager.requestList();
    }

    function jabberBlacklistReceived(blacklist) {
        var jabberBlacklist = Object.keys(blacklist).map(function(i) { return blacklist[i]; });

        var usersToUnblock = Lodash._.difference(jabberBlacklist, root.protocolOneBlacklist);
        var usersToBlock = Lodash._.difference(root.protocolOneBlacklist, jabberBlacklist);

        usersToBlock.forEach(root.jabberBlockUser);
        usersToUnblock.forEach(root.jabberUnblockUser);

        root.messenger.recentConversationItem().update();
    }

    function jabberUnblockUser(jid) {
        root.jabber.blacklistManager.unblockUser(jid);
        root.jabber.resetVcardCache(jid);

        var updateList = root.protocolOneBlacklist.filter(function(item) {
            return item != jid;
        });

        root.protocolOneBlacklist = updateList;

        Js.unblock(jid);

        root.messenger.recentConversationItem().update();
        root.onBlacklistInvalidated();
    }

    function jabberBlockUser(jid) {
        var user = { jid : jid };

        root.jabber.blacklistManager.blockUser(jid);
        root.messenger.removeContact(user);

        if (root.messenger.isSelectedUser(user)) {
            root.messenger.closeChat();
        }

        var updateList = [];
        root.protocolOneBlacklist.forEach(function(i) { updateList.push(i); } );
        updateList.push(jid);

        root.protocolOneBlacklist = updateList;

        Js.block(jid);

        root.messenger.recentConversationItem().update();
        root.onBlacklistInvalidated();
    }

    function jabberUserBlocked(jid) {
        if (!Js.isBlocked(jid)) {
            root.onBlacklistInvalidated()
        }
    }

    function jabberUserUnblocked(jid) {
        if (Js.isBlocked(jid)) {
            root.onBlacklistInvalidated()
        }
    }

    function onBlacklistInvalidated() {
        delayStart.restart();
    }

    function isUserBlocked(jid) {
        return Js.isBlocked(jid);
    }

    function blockUser(user) {
        var nickname = messenger.getNickname(user);

        MessageBox.show(qsTr("BLOCK_USER_QUESTION_CAPTION").arg(nickname),
                        qsTr("BLOCK_USER_QUESTION_TEXT").arg(nickname),
                        MessageBox.button.ok | MessageBox.button.cancel, function(result) {
                            if (result != MessageBox.button.ok) {
                                return;
                            }

                            RestApi.User.addToIgnoreList(messenger.jidToUser(user.jid),
                                function (res) {
                                    root.jabberBlockUser(user.jid);
                            });
                        });

    }

    function unblockUser(user) {
        RestApi.User.removeFromIgnoreList(messenger.jidToUser(user.jid),
            function(res) {
                if (!res || res.result != 1) {
                    return;
                }

                root.jabberUnblockUser(user.jid);
            });
    }

    Timer {
        id: delayStart

        // cache 5 seconds
        interval: 10000
        repeat: false
        triggeredOnStart: false

        onTriggered: root.beginSynchronization()
    }
}
