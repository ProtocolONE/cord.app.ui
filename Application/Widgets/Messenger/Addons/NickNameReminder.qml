import QtQuick 2.4

import Application.Core 1.0
import Application.Core.Popup 1.0

import "../Models/Messenger.js" as MessengerJs


Item {
    id: root

    property bool isShown: false

    Connections {
        target: MessengerJs.instance()
        onSelectedUserChanged: {
            var user = MessengerJs.selectedUser(MessengerJs.USER_INFO_JID);
            if (!user || !user.isValid || !user.jid || MessengerJs.isSelectedProtocolOne()) {
                return;
            }

            if (!root.isShown && !User.isNicknameValid()) {
                Popup.show('NicknameReminder');
                root.isShown = true;
            }
        }
    }

    Connections {
        target: SignalBus

        onLogoutDone: root.isShown = false;
    }
}
