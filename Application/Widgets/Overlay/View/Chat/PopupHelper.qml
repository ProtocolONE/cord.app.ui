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
import GameNet.Components.Widgets 1.0

import "../../Core/Popup.js" as TrayPopup
import "../../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    property variant messenger
    property bool enabled: true
    property bool chatVisible

    signal openChat()

    Connections {
        target: (enabled && messenger) ? messenger.signalBus() : null

        ignoreUnknownSignals: true

        onMessageReceived: {
            var user = {jid: from}
                , data
                , id;

            if (messenger.isSelectedUser(user) && root.chatVisible) {
                return;
            }

            id = 'messageReceived' + Qt.md5(from + body);
            data = {
                jid: from,
                messageText: body,
            };

            TrayPopup.showPopup(messageReceivedComp, data, id);
            GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'show', 'Overlay');
        }
    }

    Component {
        id: messageReceivedComp

        MessageReceived {
            keepIfActive: true
            destroyInterval: 12000
            messenger: root.messenger

            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'closeButton', 'Overlay');
            }

            onTimeoutClosed: {
                GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'timeoutDestroy', 'Overlay');
            }

            onAnywhereClicked: {
                var user = {jid: jid};

                messenger.selectUser(user);
                root.openChat();
                GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'anywhereClicked', 'Overlay');
            }
        }
    }
}
