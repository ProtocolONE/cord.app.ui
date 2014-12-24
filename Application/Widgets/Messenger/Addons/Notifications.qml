import QtQuick 1.1

import "../../../Core/App.js" as App
import "../Models/Messenger.js" as Messenger

Item {
    property int gamenetMessages: Messenger.getRecentConversationItem().unreadGameNetMessages ? 1 : 0
    property int rosterUnreadContacts: Messenger.getRecentConversationItem().unreadContactCount
    property int unreadContactsCount: gamenetMessages + rosterUnreadContacts

    onUnreadContactsCountChanged: {
        App.unreadContactsChanged(unreadContactsCount);
        if (unreadContactsCount > 0) {
            var count = unreadContactsCount >= 10 ? 10 : unreadContactsCount;
            App.setAnimatedTrayIcon("Assets/Images/Application/Widgets/Messenger/TrayInformer/tray" + count + ".gif");
            App.updateTaskbarIcon("Assets/Images/Application/Widgets/Messenger/TaskBarIcons/circle_" + count + ".png");
        } else {
            App.setAnimatedTrayIcon("");
            App.updateTaskbarIcon("");
        }
    }
}
