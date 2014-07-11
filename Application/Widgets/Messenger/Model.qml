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

import "./Addons" as Addons

import "./Models/Messenger.js" as MessengerJs
import "../../Core/App.js" as App

WidgetModel {
    // UNDONE коннект на запуск игры

    Connections {
        target: App.signalBus();
        onAuthDone: {
            var server = "qj.gamenet.ru"
                , user = userId
                , password = Qt.md5(appKey)
                , bareJid = user + "@" + server;

            MessengerJs.connect(bareJid, password);
        }

        onLogoutDone: MessengerJs.disconnect();
        onNavigate: MessengerJs.closeChat();
        onSettingsChange: {
            if (key === 'messengerReceivedMessage') {
                receivedMessageAddon.enabled = value;
            }
        }

    }

    Addons.Popups {
        id: receivedMessageAddon

        Component.onCompleted: {
            enabled = App.isAppSettingsEnabled('notifications', 'messengerReceivedMessage', true);
        }

        enabled: false
    }
}
