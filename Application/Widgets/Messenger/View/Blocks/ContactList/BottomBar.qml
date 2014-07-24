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
import GameNet.Controls 1.0

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs

Rectangle {
    id: root

    implicitWidth: parent.width
    implicitHeight: 32

    color: Styles.style.messengerBottomBarBackground

    property variant user: null
    property variant unreadMessageCount: user ? user.unreadMessageCount : 0

    Connections {
        target: MessengerJs.instance()
        onConnectedToServer: {
            root.user = MessengerJs.getGamenetUser();
        }
    }

    Button {
        width: 22
        height: 22

        toolTip: qsTr('MESSANGER_BOTTOM_BAR_BUTTON_NOTIFICATION_TOOLTIP')

        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        style: ButtonStyleColors {
            normal: Styles.style.messengerBottomBarButtonNormal
            hover: Styles.style.messengerBottomBarButtonHover
        }

        onClicked: {
            if (user) {
                MessengerJs.selectUser(user)
            }
        }

        Image {
            anchors.centerIn: parent
            source: installPath + "Assets/Images/Application/Widgets/Messenger/BottomBar/info.png"
        }

        Rectangle {
            color: Styles.style.messengerBottomBarButtonNotificationBackground
            anchors.fill: parent
            opacity: unreadMessageCount > 0 ? 1 : 0

            Behavior on opacity {
                PropertyAnimation {
                    duration: 200
                }
            }

            Text {
                id: txt

                text: unreadMessageCount
                color: Styles.style.messengerBottomBarButtonNotificationText
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        height: 1
        width: parent.width
        color: Qt.darker(root.color, Styles.style.darkerFactor)
        anchors.top: parent.top
    }
}
