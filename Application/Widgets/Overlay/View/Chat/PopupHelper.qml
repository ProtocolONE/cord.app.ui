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
import "./Popups.js" as Popups

import "../../../../../GameNet/Core/Analytics.js" as Ga

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
                , id;

            if (messenger.isSelectedUser(user) && root.chatVisible) {
                return;
            }

            id = 'messageReceived' + Qt.md5(from + body);

            if (!Popups.objects) {
                Popups.objects = {};
            }

            if (!Popups.objects.hasOwnProperty(from)) {
                Popups.objects[from] = TrayPopup.showPopup(messageReceivedComp, {jid: from}, id);
            }
            Popups.objects[from].addMessage(message.from, body, message);

            Ga.trackEvent('Overlay Messenger', 'show', 'MessageReceived')
        }
    }

    Component {
        id: messageReceivedComp

        MessageReceived {
            keepIfActive: true
            destroyInterval: 12000
            messenger: root.messenger

            onClosed: {
                if (Popups.objects.hasOwnProperty(jid)) {
                    delete Popups.objects[jid];
                }
            }

            onCloseButtonClicked: {
                Ga.trackEvent('Overlay Messenger', 'close', 'MessageReceived');
            }

            onTimeoutClosed: {
                Ga.trackEvent('Overlay Messenger', 'timeout', 'MessageReceived');
            }

            onAnywhereClicked: {
                var user = {jid: jid};

                messenger.selectUser(user);
                root.openChat();
                Ga.trackEvent('Overlay Messenger', 'miss click', 'MessageReceived');
            }
        }
    }
}
