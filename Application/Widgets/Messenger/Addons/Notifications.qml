import QtQuick 2.4

import Application.Core 1.0
import "../Models/Messenger.js" as Messenger

Item {
    property int gamenetMessages: Messenger.getRecentConversationItem().unreadGameNetMessages ? 1 : 0
    property int rosterUnreadContacts: Messenger.getRecentConversationItem().unreadContactCount
    property int unreadContactsCount: gamenetMessages + rosterUnreadContacts

    onUnreadContactsCountChanged: {
        SignalBus.unreadContactsChanged(unreadContactsCount);
        if (unreadContactsCount > 0) {
            var count = unreadContactsCount >= 10 ? 10 : unreadContactsCount;
            SignalBus.setAnimatedTrayIcon("Assets/Images/Application/Widgets/Messenger/TrayInformer/tray" + count + ".gif");
            SignalBus.updateTaskbarIcon("Assets/Images/Application/Widgets/Messenger/TaskBarIcons/circle_" + count + ".png");
        } else {
            SignalBus.setAnimatedTrayIcon("");
            SignalBus.updateTaskbarIcon("");
        }
    }
}
