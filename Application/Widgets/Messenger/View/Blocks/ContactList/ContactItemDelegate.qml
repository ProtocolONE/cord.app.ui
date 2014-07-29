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
import "../../../Models/Messenger.js" as Messenger

ContactItem {
    id: root

    property variant user
    property variant group

    nickname: d.nickName()
    avatar: d.avatar()
    status: d.status()
    presenceStatus: d.presenceStatus()
    isPresenceVisile: true

    isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
    isCurrent: d.isCurrent()

    onClicked: Messenger.selectUser(root.user || "", root.group || "");

    QtObject {
        id: d

        function nickName() {
            if (!root.user) {
                return "";
            }

            return Messenger.getNickname(root.user)
        }

        function avatar() {
            if (!root.user) {
                return "";
            }

            return Messenger.userAvatar(root.user);
        }

        function status() {
            if (!root.user) {
                return "";
            }

            return Messenger.userStatusMessage(root.user) || "";
        }

        function presenceStatus() {
            if (!root.user) {
                return "";
            }

            return Messenger.userPresenceState(root.user) || "";
        }

        function hasUnreadMessages() {
            if (!root.user) {
                return "";
            }

            return Messenger.hasUnreadMessages(root.user) || false;
        }

        function isCurrent() {
            if (!root.user) {
                return false;
            }

            if (!Messenger.isSelectedUser(root.user)) {
                return false;
            }


            if (!root.group || !root.group.groupId) {
                return true;
            }

            return Messenger.isSelectedGroup(root.group);
        }
    }
}
