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

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs

Rectangle {
    color: Styles.style.messengerChatDialogBodyBackground
    clip: true

    ListView {
        id: messageList

        cacheBuffer: 100
        boundsBehavior: Flickable.StopAtBounds
        interactive: true

        anchors {
            fill: parent
            rightMargin: 1
        }

        model: MessengerJs.selectedUserMessages()
        onCountChanged: messageList.positionViewAtEnd();

        delegate: MessageItem {
            width: root.width
            nickname: MessengerJs.getNickname(model)
            avatar: MessengerJs.userAvatar(model)
            date: Qt.formatDateTime(new Date(model.date), "hh:mm")
            body: model.text
            isStatusMessage: model.isStatusMessage
        }
    }

    ScrollBar {
        flickable: messageList
        anchors {
            right: parent.right
            rightMargin: 1
        }
        height: parent.height
    }

    Rectangle {
        width: 1
        height: parent.height
        color: Qt.lighter(parent.color, Styles.style.lighterFactor)
        anchors.right: parent.right
    }
}
