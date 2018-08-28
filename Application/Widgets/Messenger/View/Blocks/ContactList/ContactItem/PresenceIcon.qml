import QtQuick 2.4
import Application.Core.Styles 1.0

Rectangle {
    id: root

    property string status: ""

    function presenceStatusToColor(status) {
        switch(status) {
        case "online":
        case "chat":
            return Styles.messengerContactPresenceOnline;
        case "dnd":
        case "away":
        case "xa":
            return Styles.messengerContactPresenceDnd;
        case "offline":
        default:
            return Styles.messengerContactPresenceOffline;
        }
    }

    width: 12
    height: 12
    radius: 6
    color: root.presenceStatusToColor(root.status)
}
