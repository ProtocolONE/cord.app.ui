pragma Singleton

import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0

import "../MessengerPrivate.js" as MessengerPrivateJs

Item {
    id: root

    property variant messenger;
    property variant jabber;

    function init(jabber, extendedListModel, messenger) {
        console.log('[Recent Conversations] Init');
        root.messenger = messenger;
        root.jabber = jabber;
    }

    function getUserTalkDate(user) {
        if (!MessengerPrivateJs.lastTalkDateMap.hasOwnProperty(user.jid)) {
            return 0;
        }
        return MessengerPrivateJs.lastTalkDateMap[user.jid] || 0;
    }

    function updateUserTalkDateByJid(jid) {
        var item = messenger.getUser(jid);
        updateUserTalkDate(item);
    }

    function updateUserTalkDate(user) {
        if (!user.isValid()) {
            return;
        }

        var lastDate = Moment.moment(user.lastTalkDate).format('DD.MM.YYYY'),
            nowDate = Moment.moment().format('DD.MM.YYYY'),
            authedUserId;

        if (lastDate === nowDate) {
            return;
        }

        var now = Date.now();
        user.lastTalkDate = now;

        MessengerPrivateJs.lastTalkDateMap[user.jid] = now;
        storage.saveData(user.jid, now);
    }

    RecentConversationsStorage {
        id: storage
    }

    Connections {
        target: messenger
        ignoreUnknownSignals: true
        onBeforeConnect: {
            console.log('[Recent Conversations] Loading ', bareJid);

            storage.initDb(bareJid);
            MessengerPrivateJs.lastTalkDateMap = storage.loadData();
        }
        onMessageReceived: updateUserTalkDateByJid(from)
        onCarbonMessageReceived: updateUserTalkDateByJid(to)
    }

    Connections {
        target: jabber
        ignoreUnknownSignals: true
        onInputStatusSending: updateUserTalkDateByJid(jid)
        onMessageSending: updateUserTalkDateByJid(jid)
    }
}
