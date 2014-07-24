/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import QXmpp 1.0

QtObject {
    id: user

    property string nickname: ""
    property string jid: ""
    property string userId: ""
    property int state: QXmppMessage.Active
    property string presenceState: ""
    property string statusMessage: ""
    property string avatar: installPath + "/Assets/Images/Application/Widgets/Messenger/defaultAvatar.png";
    property int unreadMessageCount: 0

    function isValid() {
        return true;
    }
}