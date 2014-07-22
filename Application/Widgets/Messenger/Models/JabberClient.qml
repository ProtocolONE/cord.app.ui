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

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

QXmppClient {
    id: xmppClient


    //                logger: QXmppLogger {
    //                    loggingType: QXmppLogger.FileLogging
    //                    logFilePath: "D:\XmppClient.log"
    //                    messageTypes: QXmppLogger.AnyMessage
    //                }


    property int failCount: 0
    property string failDate: ""

    property variant statesMap: {
        'Active': QXmppMessage.Active,
        'Composing': QXmppMessage.Composing,
        'Inactive': QXmppMessage.Inactive,
        'Paused': QXmppMessage.Paused
    }

    function sendInputStatus(jid, value) {
        var messageMap = {
            type: QXmppMessage.Chat,
            state: statesMap[value] || value
        };

        xmppClient.sendMessage(jid, messageMap);
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
}
