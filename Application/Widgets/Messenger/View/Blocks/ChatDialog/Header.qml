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

import "../../../../../Core/App.js" as App
import "../../../../../Core/moment.js" as Moment
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs
import "../../../Models/User.js" as User

import "../ContactList" as ContactList

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: contactDelegate.height
    color: Styles.style.messengerChatDialogHeaderBackground

    ContactList.ContactItemDelegate {
        id: contactDelegate

        user: MessengerJs.selectedUser(MessengerJs.USER_INFO_JID)
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        view: "header"
    }

    Button {
        anchors {
            top: parent.top
            right: parent.right
        }

        width: 22
        height: 32

        style {
            normal: "#00000000"
            hover: "#00000000"
            disabled: "#00000000"
        }

        onClicked: MessengerJs.closeChat();

        Image {
            anchors {
                top: parent.top
                right: parent.right
                rightMargin: 5
                topMargin: 10
            }

            source: installPath + "/Assets/Images/Application/Widgets/Messenger/close_chat.png"
        }
    }
}
