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
import Tulip 1.0
import Application.Controls 1.0

import "../Models/Messenger.js" as MessengerJs

Item {
    id: root

    property alias model: view.model

    signal userClicked(string jid);

    clip: true

    implicitWidth: 228
    implicitHeight: 400

    ListView {
        id: view

        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
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

    ScrollBar {
        flickable: view
        anchors.right: parent.right
        height: parent.height
        scrollbarWidth: 5
    }
}
