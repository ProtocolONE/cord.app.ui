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

import Gamenet.Controls 1.0

import "../Models/Messenger.js" as MessengerJs

Item {
    id: root

    property string groupName: "Unknown"
    property string groupId: ""
    property bool opened: false

    property alias users: groupUserList.model

    signal groupHeaderClicked();

    clip: true
    implicitWidth: 228
    height: groupTitle.height + 2 + (root.opened ? groupUserList.height : 0)

    QtObject {
        id: d

        property int unreadUsersCount: root.opened ? 0 : d.countUnreadUsers();

        function countUnreadUsers() {
            var count = root.users.count,
                i,
                jid,
                result = 0;

            for (i = 0; i < count; ++i) {
                if (MessengerJs.hasUnreadMessages(root.users.get(i))) {
                    result += 1;
                }
            }

            return result;
        }
    }

    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    Column {
        anchors.fill: parent

        Rectangle {
            height: 1
            width: parent.width
            color: "#FFFFFF"
        }

        Rectangle {
            id: groupTitle

            width: parent.width
            height: 31
            color: "#E5E9EC"

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }

                text: root.groupName + " ( " + root.users.count + " ) "
                font {
                    family: "Arial"
                    pixelSize: 12
                    capitalization: Font.AllUppercase
                }

                color: "#8297a9"
            }

            Row {
                height: parent.height
                anchors {
                    right: parent.right
                    rightMargin: 10
                }

                spacing: 10
                layoutDirection: Qt.RightToLeft

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: installPath +
                            (root.opened
                             ? "/images/Application/Widgets/Messenger/chat_arrow_up.png"
                             : "/images/Application/Widgets/Messenger/chat_arrow_down.png")
                }

                Rectangle {
                    visible: d.unreadUsersCount > 0
                    width: 21
                    height: 16
                    radius: 7
                    color: "#189A19"
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: d.unreadUsersCount
                        color: "#FAFAFA"
                        font {
                            family: "Arial"
                            pixelSize: 12
                        }
                    }
                }
            }

            CursorMouseArea {
                anchors.fill: parent
                onClicked: {
                    MessengerJs.setGroupOpened(root, !root.opened);
                }
            }
        }

        Rectangle {
            height: 1
            width: parent.width
            color: "#E5E5E5"
        }

        ListView {
            id: groupUserList

            width: parent.width
            height: groupUserList.count > 0 ? (groupUserList.count * 53) : 1
            clip: true
            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            delegate: ContactItem {
                width: groupUserList.width
                nickname: MessengerJs.getNickname(model)

                avatar: MessengerJs.userAvatar(model)

                isCurrent: MessengerJs.isSelectedUser(model) && MessengerJs.isSelectedGroup(root)
                isUnreadMessages: !isCurrent && MessengerJs.hasUnreadMessages(model);

                onClicked: MessengerJs.selectUser(model, root);

                status: MessengerJs.userStatusMessage(model)
                presenceStatus: MessengerJs.userPresenceState(model)
            }
        }
    }
}
