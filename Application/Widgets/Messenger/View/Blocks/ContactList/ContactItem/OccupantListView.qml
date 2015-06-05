import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../../Models/Messenger.js" as Messenger

ListView {
    id: occupantView

    property string imageRoot: installPath + "Assets/Images/Application/Widgets/Messenger/ContactItem/"

    function getAvatar(user) {
        return Messenger.userAvatar(user);
    }

    function presenceStatus(user) {
        if (!user) {
            return "";
        }

        return Messenger.userPresenceState(user) || "";
    }

    implicitWidth: 9*(48+6) - 6
    spacing: 6
    interactive: false
    orientation: ListView.Horizontal

    delegate: Item {
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter

        Image {
            width: 48
            height: 48
            source: occupantView.getAvatar(model);
        }

        Image {
            visible: model.affiliation === "owner"
            anchors {
                top: parent.top
                right: parent.right
            }
            source: installPath + "/Assets/Images/Application/Widgets/Messenger/ownerIcon.png"
        }

        PresenceIcon {
            status: occupantView.presenceStatus(model)
        }

        CursorMouseArea {
            visible: model.jid != Messenger.authedUser().jid
            anchors.fill: parent
            toolTip: Messenger.getNickname(model)
            onClicked: {
                Messenger.selectUser(model);
            }
        }
    }
}
