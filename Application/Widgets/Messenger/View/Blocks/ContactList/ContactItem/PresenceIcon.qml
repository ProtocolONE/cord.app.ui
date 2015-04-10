/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import "../../../../../../Core/Styles.js" as Styles

Rectangle {
    id: root

    property string status: ""

    function presenceStatusToColor(status) {
        switch(status) {
        case "online":
        case "chat":
            return Styles.style.messengerContactPresenceOnline;
        case "dnd":
        case "away":
        case "xa":
            return Styles.style.messengerContactPresenceDnd;
        case "offline":
        default:
            return Styles.style.messengerContactPresenceOffline;
        }
    }

    width: 12
    height: 12
    radius: 6
    color: root.presenceStatusToColor(root.status)
}
