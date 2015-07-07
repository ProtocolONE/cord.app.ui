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
        width: 30
        height: 30
        anchors.centerIn: parent

        toolTip: qsTr("MESSANGER_GAMENET_NOTIFICATION_TOOLTIP") //"Уведомения от GameNet"
        style { normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
        styleImages {
            normal: installPath + Styles.style.messengerNotificationsIcon
            hover: installPath + Styles.style.messengerNotificationsIcon.replace('.png', '_hover.png')
            disabled: installPath + Styles.style.messengerNotificationsIcon
        }
        onClicked: MessengerJs.selectUser(root.user)

        Behavior on opacity {
            PropertyAnimation { duration: 250 }
        }
    }

    Rectangle {
        id: informer

        anchors {
            top: parent.top
            topMargin: 12
            right: parent.right
        }

        width: 14
        height: 14
        radius: 7
        color: Styles.style.primaryButtonNormal
        visible: root.unreadMessageCount > 0

        Text {
            text: root.unreadMessageCount
            color: Styles.style.menuText
            anchors.centerIn: parent
        }

        SequentialAnimation {
            running: informer.visible
            loops: Animation.Infinite

            PropertyAnimation { target: informer; property: 'scale'; from: 0; to: 1; duration: 100 }
            PauseAnimation { duration: 500 }
            PropertyAnimation { target: informer; property: 'anchors.topMargin'; from: 12; to: 8; duration: 100 }
            PropertyAnimation { target: informer; property: 'anchors.topMargin'; from: 8; to: 12; duration: 100 }
            PropertyAnimation { target: informer; property: 'anchors.topMargin'; from: 12; to: 10; duration: 100 }
            PropertyAnimation { target: informer; property: 'anchors.topMargin'; from: 10; to: 12; duration: 100 }
            PropertyAnimation { target: informer; property: 'anchors.topMargin'; from: 12; to: 11; duration: 100 }
            PropertyAnimation { target: informer; property: 'anchors.topMargin'; from: 11; to: 12; duration: 100 }
            PauseAnimation { duration: 2000 }
            PropertyAnimation { target: informer; property: 'scale'; to: 0; duration: 0 }
            PauseAnimation { duration: 750 }
        }
    }
}
