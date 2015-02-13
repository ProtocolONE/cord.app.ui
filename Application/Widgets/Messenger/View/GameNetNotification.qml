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
import GameNet.Components.Widgets 1.0

import "../Models/Messenger.js" as MessengerJs
import "../../../Core/Styles.js" as Styles


WidgetView {
    id: root

    property variant user: MessengerJs.getGamenetUser();
    property variant unreadMessageCount: user ? user.unreadMessageCount : 0

    implicitWidth: parent.width
    implicitHeight: parent.height

    ImageButton {
        id: gamenetNotificationButoon

        width: 30
        height: 30
        anchors.centerIn: parent

        opacity: containsMouse ? 1.0 : 0.8

        toolTip: qsTr("MESSANGER_GAMENET_NOTIFICATION_TOOLTIP") //"Уведомения от GameNet"

        style {
            normal: "#00000000"
            hover: "#00000000"
            disabled: "#00000000"
        }

        styleImages {
            normal: installPath + "Assets/Images/Application/Widgets/Messenger/gamenetNotification.png"
            hover: installPath + "Assets/Images/Application/Widgets/Messenger/gamenetNotification.png"
            disabled: installPath + "Assets/Images/Application/Widgets/Messenger/gamenetNotification.png"
        }

        onClicked: MessengerJs.selectUser(root.user)

        Behavior on opacity {
            PropertyAnimation { duration: 250 }
        }
    }

    Rectangle {
        id: messagesCountContainer

        anchors {
            top: parent.top
            topMargin: 4
            right: parent.right
        }

        width: 14
        height: 14
        radius: 7
        color: Styles.style.messengerGameNetNotificationTextBackground
        visible: root.unreadMessageCount > 0

        Text {
            id: txt

            text: root.unreadMessageCount
            color: Styles.style.messengerGameNetNotificationText
            anchors.centerIn: parent
        }
    }
}
