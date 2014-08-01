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

import "../../Core/App.js" as App
import "./Addons" as Addons
import "./Models/Messenger.js" as MessengerJs
import "./Models/Settings.js" as Settings

WidgetModel {
    settings: WidgetSettings {
        namespace: 'Messenger'
        autoSave: ['chatBodyHeight']

        property bool messengerReceivedMessage: true
        property int sendAction: Settings.SendShortCut.Enter
        property int chatBodyHeight: 470
    }

    // UNDONE коннект на запуск игры
    Connections {
        target: App.signalBus();
        onAuthDone: {
            MessengerJs.connect("qj.gamenet.ru", userId, appKey);
        }

        onLogoutDone: MessengerJs.disconnect();
        onNavigate: MessengerJs.closeChat();
    }

    Addons.Popups {
        enabled: settings.messengerReceivedMessage
    }
}
