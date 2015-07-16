/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
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
