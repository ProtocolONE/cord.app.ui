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
import "../../../Models/Group.js" as Group
import "../../../../../Core/moment.js" as Moment

import "../../../../../Core/App.js" as App
import "../../../../../../GameNet/Core/lodash.js" as Lodash

ContactItem {
    id: root

    property variant user
    property variant group

    nickname: d.nickName()
    avatar: d.avatar()
    status: d.status()
    extendedStatus: d.getExtendedStatus()
    presenceStatus: d.presenceStatus()
    isPresenceVisile: true

    isUnreadMessages: !root.isCurrent && d.hasUnreadMessages();
    isCurrent: d.isCurrent()
    userId: d.userId()

    function select() {
        Messenger.selectUser(root.user || "", root.group || "");
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

            if (!Messenger.isSelectedUser(root.user)) {
                return false;
            }


            if (!root.group || !root.group.groupId) {
                return true;
            }

            return Messenger.isSelectedGroup(root.group);
        }

        function userId() {
            if (!root.user) {
                return "";
            }

            return Messenger.jidToUser(root.user.jid);
        }

        function getExtendedStatus() {
            var groups;
            if (!root.user) {
                return "";
            }

            groups = Messenger.getUserGroups(root.user);

            if (groups.length === 1 && groups[0] === "GameNet") {
                return qsTr("CONTACT_ITEM_EXTENDED_STATUS_ONLY_GAMENET_FRINED"); // "Друг на сайте GameNet"
            }

            groups = Lodash._.chain(groups)
                .reduce(function(a, g) {
                    if (g === Group.getNoGroupId()) {
                        return a;
                    }

                    if (g === "GameNet") {
                        a.push({
                                   id: g,
                                   name: qsTr("CONTACT_ITEM_EXTENDED_STATUS_GAMENET_FRINED"),// "на сайте GameNet",
                                   isGameNet: 1
                               });
                        return a;
                    }

                    a.push({
                               id: g,
                               name: g.split('(')[0].trim(),
                               isGameNet: 0
                           });
                    return a;

                }, [])
                .sortByAll(['name', 'isGameNet'])
                .pluck('name')
                .uniq()
                .join(', ')
                .value();

            return groups
                    ?  qsTr("CONTACT_ITEM_EXTENDED_STATUS").arg(groups) //qsTr("Друг в %1").arg(groups)
                    : "";
        }
    }
}
