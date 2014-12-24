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

    property variant user: MessengerJs.getGamenetUser();
    property variant unreadMessageCount: user ? user.unreadMessageCount : 0
    property alias gameFilterChecked: gameFilterCheckbox.checked

    onUnreadMessageCountChanged: messagesCountContainer.opacity = 0;

    implicitWidth: parent.width
    implicitHeight: 32

    color: Styles.style.messengerBottomBarBackground

    Row {
        anchors.fill: parent
        anchors.leftMargin: 5
        spacing: 20

        Button {
            width: 22
            height: 22

            toolTip: qsTr('MESSANGER_BOTTOM_BAR_BUTTON_NOTIFICATION_TOOLTIP')

            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                if (root.user) {
                    MessengerJs.selectUser(root.user)
                }
            }

            Image {
                anchors.centerIn: parent
                source: installPath + "Assets/Images/Application/Widgets/Messenger/BottomBar/info.png"
            }

            Rectangle {
                id: messagesCountContainer

                color: Styles.style.messengerBottomBarButtonNotificationBackground
                anchors.fill: parent
                opacity: 0

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

            Timer {
                id: animationTimer

                running: root.unreadMessageCount > 0
                interval: 600
                repeat: true
                onTriggered: messagesCountContainer.opacity = (messagesCountContainer.opacity == 0 ? 1 : 0);
            }
        }

        CheckBox {
            id: gameFilterCheckbox

            width: 100
            height: 12
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("MESSENGER_PLAYING_GAME_FILTER")
            fontSize: 14

            style {
                normal: Styles.style.messengerPlayingContactFilterNormal
                hover: Styles.style.messengerPlayingContactFilterHover
                active: Styles.style.messengerPlayingContactFilterDisabled
                disabled: Styles.style.messengerPlayingContactFilterActive
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
