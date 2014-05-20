import QtQuick 1.1
import Tulip 1.0

import "../Models/Messenger.js" as MessengerJs

ListView {
    id: root

    signal userClicked(string jid);

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    delegate: ContactItem {
        width: root.width
        height: 53
        nickname: MessengerJs.getNickname(model)
        avatar: "http://images.gamenet.ru/pics/user/avatar/small/empty2.jpg"
        onClicked: {
            root.userClicked(model.jid);
            MessengerJs.selectUser(model);
        }
    }
}
