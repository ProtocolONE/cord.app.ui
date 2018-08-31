import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import "../../Core/Popup.js" as TrayPopup
import "./Popups.js" as Popups

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
