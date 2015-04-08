/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import QXmpp 1.0
import Tulip 1.0

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../Core/moment.js" as Moment
import "User.js" as User

import "JabberClient.js" as Js

QXmppClient {
    id: xmppClient

    //                logger: QXmppLogger {
    //                    loggingType: QXmppLogger.FileLogging
    //                    logFilePath: "D:\XmppClient.log"
    //                    messageTypes: QXmppLogger.AnyMessage
    //                }

    property int failCount: 0
    property string failDate: ""
    property string myJid: ""

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
        xmppClient.myJid = jid;
        xmppClient.connectToServer(jid, password, params);
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

    function getLastActivity(jid) {
        xmppClient.lastActivityManager.requestLastActivity(jid);
        return Js.lastActivityCache[jid] || 0;
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

        jid = User.jidWithoutResource(lastActivity.from);
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

    Component.onCompleted: {
        var cache;
        try {
            cache = JSON.parse(Settings.value('qml/messenger/cache/', 'lastActivity' , '{}'));
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
        //if (error == XmppClient.SocketError) {
        //  console.log("Error due to TCP socket.");
        //} else if (error == XmppClient.KeepAliveError) {
        //  console.log("Error due to no response to a keep alive.");
        //} else if (error == XmppClient.XmppStreamError) {
        //  console.log("Error due to XML stream.");
        //}
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
            GoogleAnalytics.trackEvent('/jabber/0.2/', 'Error', 'Code ' + code, "Try count" + xmppClient.failCount);
        }
    }

    Connections {
        target: xmppClient.lastActivityManager
        onLastActivityUpdated: xmppClient.processLastActiviteResponse(lastActivity);
    }

    Timer {
        id: autoSaveDelay

        interval: 5000
        onTriggered: Settings.setValue('qml/messenger/cache/', 'lastActivity' , JSON.stringify(Js.lastActivityCache));
    }

    Connections {
        target: xmppClient.pepManager
        onGamingReceived: xmppClient.gamingInfoReceived(game);
    }
}
