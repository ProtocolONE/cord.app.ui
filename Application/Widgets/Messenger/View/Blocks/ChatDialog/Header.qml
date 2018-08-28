import QtQuick 2.4
import Tulip 1.0

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Core.Styles 1.0

import "../../../Models/Messenger.js" as MessengerJs

import "../ContactList" as ContactList

Item {
    id: root

    implicitWidth: parent.width
    implicitHeight: contactDelegate.height

    Rectangle {
        anchors.fill: parent
        color: Styles.contentBackgroundLight
        opacity: 0.15
    }

    ContactList.ContactItemDelegate {
        id: contactDelegate

        user: MessengerJs.selectedUser(MessengerJs.USER_INFO_JID)
        anchors {
            left: parent.left
            right: parent.right
            rightMargin: 36
            top: parent.top
        }

        view: "header"
    }

    Button {
        anchors {
            top: parent.top
            right: parent.right
        }

        width: 30
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
                rightMargin: 12
                topMargin: 12
            }

            source: installPath + Styles.messengerChatClose
        }
    }
}
