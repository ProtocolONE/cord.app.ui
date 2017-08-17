/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import QXmpp 1.0
import Tulip 1.0
import GameNet.Core 1.0
import Application.Core.Settings 1.0

import "User.js" as UserJs

import "JabberClient.js" as Js

QXmppClient {
    id: xmppClient

    property int failCount: 0
    property string failDate: ""
    property string myJid: ""
    property var myJPassword: ""
    property var myJParams: ""

    property variant statesMap: {
        'Active': QXmppMessage.Active,
        'Composing': QXmppMessage.Composing,
        'Inactive': QXmppMessage.Inactive,
        'Paused': QXmppMessage.Paused
    }

    signal lastActivityUpdated(string jid, int timestamp);
    signal gamingInfoReceived(variant info);

    /**
      INFO https://jira.gamenet.ru:8443/browse/QGNA-1130

      Этот врапер нужен для того, чтобы проверка на специальное событие не расползалась по всему коду приложения.
      Если где-то вам потребуется обычное сообщение - просто подписывайтесь на MessageReceived вместо
      MessageReceivedEx.

      @param QmlQXmppMessage message
    */
    signal messageReceivedEx(variant message);
    signal eventReceived(variant event);

    signal messageSending(string jid, variant message);
    signal inputStatusSending(string jid, variant message);

    function connectToServerEx(jid, password, params) {
        console.log('connectEx to jabber ' + jid);

        // Save to reconnect
        xmppClient.myJPassword = password;
        xmppClient.myJParams = params;
        xmppClient.myJid = jid;

        var config = xmppClient.configuration;
        config.jid = jid;
        config.password = password;
        if (params.hasOwnProperty('resource')) {
            config.resource = params.resource;
        }

        if (params.hasOwnProperty('streamManagementMode')) {
            config.streamManagementMode = params.streamManagementMode;
        }

        config.keepAliveInterval = 120;
        config.keepAliveTimeout = 120;

        xmppClient.connectUsingConfiguration();
    }

    function sendMessageEx(jid, message) {
        messageSending(jid, message);
        xmppClient.sendMessage(jid, message);
    }

    function sendInputStatus(jid, value) {
        var messageMap = {
            type: QXmppMessage.Chat,
            state: statesMap[value] || value
        };

        inputStatusSending(jid, messageMap);
        xmppClient.sendMessage(jid, messageMap);
    }

    function isLastActivityRequested(jid) {
        return Js.lastActivityCacheQueue.hasOwnProperty(jid);
    }

    function getLastActivity(jid, force) {
        if (force || !Js.lastActivityCacheQueue.hasOwnProperty(jid)) {
            xmppClient.lastActivityManager.requestLastActivity(jid);
            Js.lastActivityCacheQueue[jid] = 1;
        }
    }

    function processLastActiviteResponse(lastActivity) {
        var date,
            jid,
            current;

        if (lastActivity.seconds < 0) {
            return;
        }

        date = (+Moment.moment().subtract(lastActivity.seconds, 'seconds'))/1000 | 0;
        current = Js.lastActivityCache[jid];

        if (date == current) {
            return;
        }

        jid = UserJs.jidWithoutResource(lastActivity.from);
        Js.lastActivityCache[jid] = date;
        autoSaveDelay.restart();
        xmppClient.lastActivityUpdated(jid, date);
    }

    function setGamingInfo(opt) {
        var gameInfo;
        if (opt) {
            gameInfo = {
                characterName: opt.characterName || '',
                characterProfile: opt.characterProfile || '',
                name: opt.name || '',
                level: opt.level || '',
                serverAddress: opt.serverAddress || '',
                serverName: opt.serverName || '',
                uri: opt.uri || ''
            };
        }

        xmppClient.pepManager.setGamingInfo(gameInfo);
    }

    function isEvent(message) {
        return (message.from === 'GameNet')
                && message.body.indexOf('EVENT:') === 0;
    }

    function parseEvent(message) {
        return JSON.parse(message.body.substr(6))
    }

    function leaveGroup(roomJid) {
        xmppClient.mucManager.setPermission(roomJid, xmppClient.myJid, 'none');
    }

    function invite(roomJid, jid, reason) {
        var bareJid = UserJs.jidWithoutResource(jid)
        xmppClient.mucManager.sendInvitationMediated(roomJid, jid, reason || "");
    }

    function joinRoomInternal(roomJid, userJid, lastMessageDate) {
        xmppClient.mucManager.addRoom(roomJid);
        xmppClient.mucManager.join(
                    roomJid,
                    userJid,
                    {
                        history: {
                            since: lastMessageDate
                        }
                    });
    }

    function serverUrl() {
        return UserJs.serverUrl;
    }

    function conferenceUrl() {
        return UserJs.conferenceUrl();
    }

    function isVcardRequested(jid) {
        return Js.vcardQueue.hasOwnProperty(jid);
    }

    function requestVcard(jid) {
        if (Js.vcardQueue.hasOwnProperty(jid)) {
            return;
        }

        if (xmppClient.vcardManager.requestVCard(jid)) {
            Js.vcardQueue[jid] = 1;
        }
    }

    function resetVcardCache(jid) {
        delete Js.vcardQueue[jid];
    }

    onDisconnected: {
        console.log('onDisconnected from jabber');
        Js.vcardQueue = {};
        Js.lastActivityCacheQueue = {};
    }

    Component.onCompleted: {
        var cache;
        try {
            cache = JSON.parse(AppSettings.value('qml/messenger/cache/', 'lastActivity' , '{}'));
        } catch(e) {
            cache = {};
        }

        Js.lastActivityCache = cache;
    }

    onMessageReceived: {
        if (isEvent(message)) {
            try {
                xmppClient.eventReceived(parseEvent(message));
            } catch (e) {
                console.log('Error parsing event message ', message.body);
                return;
            }
            return;
        }

        xmppClient.messageReceivedEx(message);
    }

    onError: {
        var today = Qt.formatDateTime(new Date(), "dd.MM.yyyy");

        if (xmppClient.failDate != today) {
            xmppClient.failCount = 0;
            xmppClient.failDate = today;
        }

        xmppClient.failCount += 1;

        if (xmppClient.failCount <= 14) {
            console.log('Jabber error sended Code: ', code, 'Count: ', xmppClient.failCount, ' Today: ', xmppClient.failDate);
        }

        var shoudlTrackConnectionFail = (xmppClient.failCount === 1) // 10 секунд - бывает.
            || (xmppClient.failCount === 4) // 40 секунд лучше бы столько клиенту не ждать.
            || (xmppClient.failCount === 14); // 340 секунд - это уже недопустимо.

        if (shoudlTrackConnectionFail) {
            Ga.trackException('Jabber error: Code ' + code + " Try count " + xmppClient.failCount, false);
        }

        if (code == 3) { // XmppStreamError (Error due to XML stream)
            console.log("Need self reconnect");
            xmppClient.disconnectFromServer();
            reconnectTimer.restart();
	}
    }

    Connections {
        target: xmppClient.lastActivityManager
        onLastActivityUpdated: xmppClient.processLastActiviteResponse(lastActivity);
    }

    Timer {
        id: autoSaveDelay

        interval: 5000
        onTriggered: AppSettings.setValue('qml/messenger/cache/', 'lastActivity' , JSON.stringify(Js.lastActivityCache));
    }

    Connections {
        target: xmppClient.pepManager
        onGamingReceived: xmppClient.gamingInfoReceived(game);
    }

    Timer {
        id: reconnectTimer
        interval: 20000
        repeat: false
        onTriggered: {
            console.log("Try to reconnect to Jabber");
            xmppClient.connectToServerEx(xmppClient.myJid, xmppClient.myJPassword, xmppClient.myJParams);
        }
    }
}
