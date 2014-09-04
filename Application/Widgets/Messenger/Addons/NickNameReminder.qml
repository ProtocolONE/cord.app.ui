import QtQuick 1.1

import "../Models/Messenger.js" as MessengerJs

import "../../../Core/App.js" as App
import "../../../Core/User.js" as User
import "../../../Core/Popup.js" as Popup

Item {
    id: root

    property bool isShown: false

    Connections {
        target: MessengerJs.instance()
        onSelectedUserChanged: {
            var user = MessengerJs.selectedUser(MessengerJs.USER_INFO_JID);
            if (!user || !user.jid || MessengerJs.isSelectedGamenet()) {
                return;
            }

            if (!root.isShown && !User.isNicknameValid()) {
                Popup.show('NicknameReminder');
                root.isShown = true;
            }
        }
    }

    Connections {
        target: App.signalBus();

        onLogoutDone: root.isShown = false;
    }
}
