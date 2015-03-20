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
import "../../../Models/User.js" as User
import "../../../../../Core/moment.js" as Moment

import "../../../../../Core/App.js" as App
import "../../../../../../GameNet/Core/lodash.js" as Lodash

ContactItem {
    id: root

    property variant user

    nickname: d.nickName()
    avatar: d.avatar()
    status: d.status()
    extendedStatus: ''
    presenceStatus: d.presenceStatus()
    isPresenceVisile: true

    isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
    isCurrent: d.isCurrent()
    userId: d.userId()

    function select() {
        Messenger.selectUser(root.user || "");
    }

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

            if (User.isOnline(root.presenceStatus)) {
                var serviceId = Messenger.gamePlayingByUser(root.user);
                if (serviceId) {
                    var gameInfo = App.serviceItemByServiceId(serviceId);
                    if (gameInfo) {
                        return qsTr("MESSENGER_CONTACT_ITEM_PLAYING_STATUS_INFO").arg(gameInfo.name);
                    }
                }

                return Messenger.userStatusMessage(root.user) || "";
            }

            var lastActivity = Messenger.userLastActivity(root.user);
            if (!lastActivity) {
                return "";
            }

            var currentTime = Math.max(Messenger.getCurrentTime() * 1000, Date.now());

            return qsTr("LAST_ACTIVITY_PLACEHOLDER").arg(Moment.moment(lastActivity * 1000).from(currentTime));
        }

        function presenceStatus() {
            if (!root.user) {
                return "";
            }

            return Messenger.userPresenceState(root.user) || "";
        }

        function hasUnreadMessages() {
            if (!root.user) {
                return false;
            }

            return Messenger.hasUnreadMessages(root.user) || false;
        }

        function isCurrent() {
            if (!root.user) {
                return false;
            }

            return Messenger.isSelectedUser(root.user);
        }

        function userId() {
            if (!root.user) {
                return "";
            }

            return Messenger.jidToUser(root.user.jid);
        }
    }
}
