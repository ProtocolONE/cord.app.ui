import QtQuick 2.4

import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core.Styles 1.0

import "../Models/Messenger.js" as MessengerJs

WidgetView {
    id: root

    property variant user: MessengerJs.getProtocolOneUser();
    property variant unreadMessageCount: getMessageCount()

    function getMessageCount() {
        if (!user) {
            return 0;
        }
        return user.unreadMessageCount;
    }

    implicitWidth: parent.width
    implicitHeight: parent.height

    ImageButton {
        width: 30
        height: 30
        anchors.centerIn: parent

        toolTip: qsTr("MESSANGER_PROTOCOLONE_NOTIFICATION_TOOLTIP") //"Уведомения от ProtocolOne"
        style { normal: "#00000000"; hover: "#00000000"; disabled: "#00000000"}
        styleImages {
            normal: installPath + Styles.messengerNotificationsIcon
            hover: installPath + Styles.messengerNotificationsIcon.replace('.png', '_hover.png')
            disabled: installPath + Styles.messengerNotificationsIcon
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
        color: Styles.primaryButtonNormal
        visible: root.unreadMessageCount > 0

        Text {
            text: root.unreadMessageCount < 10 ? root.unreadMessageCount : '9+';
            color: Styles.menuText
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
