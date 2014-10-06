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

import "../Models/Messenger.js" as MessengerJs
import "../../../Core/App.js" as App
import "../../../Core/TrayPopup.js" as TrayPopup
import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    property bool enabled: true

    Connections {
        target: enabled ? MessengerJs.instance() : null;
        ignoreUnknownSignals: true

        onMessageReceived: {
            var user = {jid: from}
                , data
                , id;

            if (App.isOverlayEnabled()) {
                return;
            }

            if (MessengerJs.isSelectedUser(user) && Qt.application.active) {
                return;
            }

            id = 'messageReceived' + Qt.md5(from + body);
            data = {
                jid: from,
                messageText: body,
            };

            TrayPopup.showPopup(messageReceivedComp, data, id);
            GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'show', 'App');
        }
    }

    Component {
        id: messageReceivedComp

        MessageReceived {
            keepIfActive: true
            destroyInterval: 12000

            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'closeButton', 'App');
            }

            onTimeoutClosed: {
                GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'timeoutDestroy', 'App');
            }

            onAnywhereClicked: {
                var user = {jid: jid};

                App.activateWindow();
                MessengerJs.selectUser(user)

                GoogleAnalytics.trackEvent('Messenger', 'NewMessagePopup', 'anywhereClicked', 'App');
            }
        }
    }
}
