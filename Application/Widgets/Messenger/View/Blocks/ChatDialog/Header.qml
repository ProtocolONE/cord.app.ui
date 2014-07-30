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

import "../../../../../Core/moment.js" as Moment
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs

import "../ContactList" as ContactList

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: 52
    color: Styles.style.messengerChatDialogHeaderBackground

//    function getText() {
//        var selectedUser = MessengerJs.selectedUser();
//        if (!selectedUser.isValid()) {
//            return "";
//        }

//        var lastActivity = MessengerJs.userLastActivity(selectedUser);

//        if (lastActivity < 0) {
//            return "";
//        }

//        var lastActivityTime = Moment.moment().subtract(lastActivity, 'seconds');
//        return qsTr("LAST_ACTIVITY_TODAY").arg( Moment.moment(lastActivityTime).lang('ru').fromNow());
//    }

//    ContactList.ContactItem {
//        anchors.fill: parent

//        isCurrent: true
//        avatar: MessengerJs.userAvatar(MessengerJs.selectedUser())
//        nickname: MessengerJs.selectedUserNickname();
//        status: root.getText();
//    }


   Row {
       anchors.fill: parent

        Item {
            width: parent.height
            height: parent.height

            Image {
                source: MessengerJs.userAvatar(MessengerJs.selectedUser())
                width: 32
                height: 32
                anchors.centerIn: parent
            }
        }

        Item {
            width: parent.width - parent.height - 250
            height: parent.height

            Text {
                text: MessengerJs.selectedUserNickname();
                color: Styles.style.messengerChatDialogHeaderNicknameText
                anchors.verticalCenter: parent.verticalCenter
                font {
                    pixelSize: 18
                    family: "Arial"
                }
            }
        }
    }

    Item {
        id: lastActivityText

        width: childrenRect.width
        height: parent.height
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: 45
        }

        function getText() {
            var selectedUser = MessengerJs.selectedUser();
            if (!selectedUser.isValid()) {
                return "";
            }

            var lastActivity = MessengerJs.userLastActivity(selectedUser);

            if (lastActivity < 0) {
                return "";
            }

            var lastActivityTime = Moment.moment().subtract(lastActivity, 'seconds');
            return qsTr("LAST_ACTIVITY_PLACEHOLDER").arg( Moment.moment(lastActivityTime).lang('ru').fromNow());
        }

        Text {
            text: lastActivityText.getText();
            color: Styles.style.messengerChatDialogHeaderNicknameText
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignRight
            font {
                pixelSize: 16
                family: "Arial"
            }
        }
    }

    ImageButton {
        anchors {
            top: parent.top
            right: parent.right
            rightMargin: 1
        }

        width: 32
        height: 32
        styleImages: ButtonStyleImages {
            normal: installPath + "/Assets/Images/Application/Widgets/Messenger/close_chat.png"
            hover: installPath + "/Assets/Images/Application/Widgets/Messenger/close_chat.png"
            disabled: installPath + "/Assets/Images/Application/Widgets/Messenger/close_chat.png"
        }

        style: ButtonStyleColors {
            normal: "#00000000"
            hover: "#00000000"
            disabled: "#00000000"
        }

        onClicked: MessengerJs.closeChat();
    }

    Rectangle {
        width: 1
        height: parent.height
        color: Qt.lighter(root.color, Styles.style.lighterFactor)
        anchors {
            right: parent.right
        }
    }
}
