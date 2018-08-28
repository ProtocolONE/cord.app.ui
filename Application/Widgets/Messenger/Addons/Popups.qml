import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Widgets.Messenger.Plugins.CheckFullScreen 1.0

import "../Models/Messenger.js" as MessengerJs
import "./Popups.js" as Popups

Item {
    property bool enabled: true

    Connections {
        target: enabled ? MessengerJs.instance() : null;
        ignoreUnknownSignals: true

        onMessageReceived: {
            var user = {jid: from}
                , id;

            if (message.isReplaceMessage) {
                return;
            }

            if (App.isOverlayEnabled()) {
                return;
            }

            if (MessengerJs.isSelectedUser(user) && Qt.application.active) {
                return;
            }

            if (App.isServiceRunning('30000000000') /*BlackDesert id*/ &&
                    CheckFullScreen.isFullScreen()) {
                return;
            }

            id = 'messageReceived' + Qt.md5(from + body);
            if (!Popups.objects.hasOwnProperty(from)) {
                Popups.objects[from] = TrayPopup.showPopup(messageReceivedComp, {jid: from}, id);
            }
            Popups.objects[from].addMessage(message.from, body, message);

            Ga.trackEvent('Messenger Popup', 'show', 'MessageReveived');
        }
    }

    Component {
        id: messageReceivedComp

        MessageReceived {
            keepIfActive: true
            destroyInterval: 12000

            onClosed: {
                delete Popups.objects[jid];
            }

            onCloseButtonClicked: {
                Ga.trackEvent('Messenger Popup', 'close', 'MessageReveived');
            }

            onTimeoutClosed: {
                Ga.trackEvent('Messenger Popup', 'timeout close', 'MessageReveived');
            }

            onAnywhereClicked: {
                var user = {jid: jid};

                App.activateWindow();
                MessengerJs.selectUser(user)

                Ga.trackEvent('Messenger Popup', 'miss click', 'MessageReveived');
            }
        }
    }
}
