import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Config 1.0

import "./Addons" as Addons

import "./Models/Messenger.js" as MessengerJs
import "./Models/Settings.js" as Settings

WidgetModel {
    id: root

    settings: WidgetSettings {
        namespace: 'Messenger'
        autoSave: ['chatBodyHeight']

        property bool messengerReceivedMessage: true
        property int sendAction: Settings.SendShortCut.Enter
        property int chatBodyHeight: 470
        property string historySaveInterval: '0'
    }

    function clearHistory() {
        MessengerJs.clearHistory();
    }

    function signalBus() {
        return MessengerJs.instance();
    }

    function userSelected() {
        return MessengerJs.userSelected();
    }

    function selectUser(user) {
        MessengerJs.selectUser(user);
    }

    function userAvatar(item) {
        return MessengerJs.userAvatar(item);
    }

    function getNickname(item) {
        return MessengerJs.getNickname(item);
    }

    function userPlayingGame(item) {
        return MessengerJs.userPlayingGame(item);
    }

    function isSelectedUser(user) {
        return MessengerJs.isSelectedUser(user)
    }

    function getUser(jid) {
        return MessengerJs.getUser(jid);
    }

    Connections {
        target: SignalBus
//        onAuthDone: {
//            MessengerJs.connect(Config.value("jabber\\url", "qj.gamenet.ru"), userId, appKey);
//        }

        onLogoutDone: MessengerJs.disconnect();
        onNavigate: MessengerJs.closeChat();
        onExitApplication: MessengerJs.disconnect();
    }

    Binding {
        target: MessengerJs.instance()
        property: "historySaveInterval"
        value: settings.historySaveInterval
    }

    Addons.Popups {
        enabled: settings.messengerReceivedMessage
    }

    Addons.NickNameReminder {}

    Addons.Notifications {}
}
