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
import Application.Controls 1.0

import "../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../../Core/Styles.js" as Styles


import "../User.js" as User

import "./PlainContacts.js" as Js

Item {
    id: root

    property variant messenger
    property alias proxyModel: groupProxyModel

    function userCount(groupId) {
        return d.userCount(groupId)
    }

    function closeGroup(groupId) {
        d.closeGroup(groupId)
    }

    function openGroup(groupId) {
        d.openGroup(groupId);
    }

    function countUnreadUsers(groupId) {
        return d.countUnreadUsers(groupId)
    }

    QtObject {
        id: d

        function forEachOpenedGroup(cb) {
            Object.keys(Js.groupsMap).filter(function(g) {
                return Js.isOpened(g);
            }).forEach(cb);
        }

        function findUserIndex(data, user) {
            return Lodash._.findIndex(data, function(u) {
                return u === user;
            });
        }

        function updateModel() {

            var groupIds = messenger.getGroupsModel().keys()
                , itemCount
                , index
                , remvoeGroupIndex;

            Lodash._.difference(groupIds, Object.keys(Js.groupsMap)).forEach(function(groupId) {
                itemCount = Js.itemCount();
                index = Js.appendGroup(groupId);
                if (index === -1) {
                    index = itemCount;
                }

                Js.queueAppendGroupItemJob(index, groupId);
            });

            Lodash._.difference(Object.keys(Js.groupsMap), groupIds).forEach(function(groupId) {
                remvoeGroupIndex = Js.calculateInsertIndex(groupId);
                itemCount = Js.isOpened(groupId) ? Js.groupById(groupId).users.length : 1;

                Js.queueRemoveItemJob(remvoeGroupIndex, itemCount);
                Js.removeGroup(groupId);
            });

            d.updateOpenedGroups();
        }

        function updateOpenedGroups() {
            d.forEachOpenedGroup(function(openedId) {
                var currentUsers = Js.groupById(openedId).users,
                    actualUsers = [],
                    actualUsersMap = {},
                    groupStartIndex,
                    usersToInsert,
                    usersToRemove;

                d.buildReduceMap(openedId, actualUsersMap, actualUsers);

                groupStartIndex = Js.calculateInsertIndex(openedId);
                usersToInsert = Lodash._.difference(actualUsers, currentUsers);
                usersToRemove = Lodash._.difference(currentUsers, actualUsers);

                d.insertUsersToOpenedGroup(usersToInsert, currentUsers, groupStartIndex, openedId);
                d.removeFromOpenedGroup(usersToRemove, currentUsers, groupStartIndex);
            });
        }

        function buildReduceMap(openedId, actualUsersMap, actualUsers) {
            var usersModel = messenger.getUsersModel()
                , actualUserModel = messenger.getGroupsModel().getById(openedId).users
                , modelUser
                , jid
                , i
                , userInfo;

            for (i = 0; i < actualUserModel.count; ++i) {
                modelUser = actualUserModel.get(i)
                jid = modelUser.jid;

                userInfo = usersModel.getById(jid);
                actualUsersMap[jid] =
                    {
                        online: User.isOnline(userInfo.presenceState),
                        nickname: userInfo.nickname.toLowerCase(),
                        lastActivity: messenger.getUser(jid).lastActivity
                    };

                actualUsers.push(jid);
            }
        }

        function insertUsersToOpenedGroup(users, currentUsers, groupStartIndex, openedId) {
            users.forEach(function(newUser) {
                var newUserNickName,
                    newUserInsertIndex;

                newUserNickName = messenger.getUsersModel().getById(newUser).nickname.toLowerCase();
                newUserInsertIndex = Lodash._.findIndex(currentUsers, function(u) {
                    return actualUsersMap[u].nickname > newUserNickName;
                });

                newUserInsertIndex = newUserInsertIndex >= 0 ? newUserInsertIndex : currentUsers.length;
                currentUsers.splice(newUserInsertIndex, 0, newUser);
                Js.queueAppendAllJob(groupStartIndex + newUserInsertIndex, openedId, [newUser]);
            });
        }

        function removeFromOpenedGroup(users, currentUsers, groupStartIndex) {
            users.forEach(function(deletedUser) {
                var deleteIndex = d.findUserIndex(currentUsers, deletedUser);
                currentUsers.splice(deleteIndex, 1);
                Js.queueRemoveItemJob(groupStartIndex + deleteIndex, 1);
            });
        }

        function openGroup(groupId, index) {
            var users = []
                , usersMap = {}
                , insertIndex
                , group;

            if (Js.hasJobs()) {
                return;
            }

            d.buildReduceMap(groupId, usersMap, users);

            users.sort(function(a, b) {
                var online1 = usersMap[a].online;
                var online2 = usersMap[b].online;

                if (online1 && !online2) {
                    return -1;
                }

                if (!online1 && online2) {
                    return 1;
                }

                var lastActivity1 = usersMap[a].lastActivity;
                var lastActivity2 = usersMap[b].lastActivity;

                if ((lastActivity1 > 0) && (lastActivity2 == 0)) {
                    return -1;
                }

                if ((lastActivity1 == 0) && (lastActivity2 > 0)) {
                    return 1;
                }

                var val1 = usersMap[a].nickname;
                var val2 = usersMap[b].nickname;

                if (val1 === val2) {
                    return 0;
                }

                if (val1 < val2) {
                    return -1;
                }

                return 1;
            });

            insertIndex = Js.calculateInsertIndex(groupId);
            group = Js.groupById(groupId);
            group.users = users.slice(0);

            Js.setGroupOpened(groupId, true);
            Js.queueAppendAllJob(insertIndex, groupId, users, true);
        }

        function closeGroup(groupId) {
            var ind, group, usersLen;

            if (Js.hasJobs()) {
                return;
            }

            ind = Js.calculateInsertIndex(groupId);

            Js.setGroupOpened(groupId, false);
            group = Js.groupById(groupId);
            usersLen = group.users.length;
            Js.queueRemoveItemJob(ind, usersLen, groupId);
            Js.groupsMap[groupId].users = [];
        }

        function userCount(groupId) {
            var group = messenger.getGroupsModel().getById(groupId);
            if (!group) {
                return 0;
            }

            return group.users.count;
        }

        function countUnreadUsers(groupId) {
            var group = messenger.getGroupsModel().getById(groupId);

            if (!group) {
                return 0;
            }

            var users = group.users,
                count = users.count,
                i,
                result = 0;

            for (i = 0; i < count; ++i) {
                if (messenger.hasUnreadMessages(users.get(i))) {
                    result += 1;
                }
            }

            return result;
        }

        function updateUserOrderPosition(jid) {
            d.forEachOpenedGroup(function(openedId) {
                var group;
                group = Js.groupById(openedId);

                var index = d.findUserIndex(group.users, jid);
                if (index === -1) {
                    return;
                }

                group.users.splice(index, 1);

                var user = messenger.getUser(jid),
                    online = user.online,
                    nickname = user.nickname.toLowerCase(),
                    lastActivity = user.lastActivity;

                var insertIndex = Lodash._.findIndex(group.users, function(u) {
                    var user1 = messenger.getUser(u),
                        online1 = user1.online,
                        nickname1 = user1.nickname.toLowerCase(),
                        lastActivity1 = user1.lastActivity;

                    if (online && !online1) {
                        return true;
                    }

                    if (!online && online1) {
                        return false;
                    }

                    if ((lastActivity > 0) && (lastActivity1 == 0)) {
                        return true;
                    }

                    if ((lastActivity == 0) && (lastActivity1 > 0)) {
                        return false;
                    }

                    return nickname1 > nickname;
                });

                insertIndex = insertIndex >= 0 ? insertIndex : group.users.length;
                group.users.splice(insertIndex, 0, jid);

                var groupIndex = Js.calculateInsertIndex(openedId);
                Js.queueMoveItemJob(index + groupIndex, insertIndex + groupIndex);
            });
        }
    }

    Timer {
        interval: 5
        running: true
        repeat: true
        onTriggered: Js.processJob(groupProxyModel);
    }

    Connections {
        target: messenger
        onOnlineStatusChanged: d.updateUserOrderPosition(jid);
        onLastActivityChanged: d.updateUserOrderPosition(jid);
    }

    Connections {
        target: messenger.getGroupsModel()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: messenger.getUsersModel()
        onSourceChanged: d.updateModel();
    }

    ListModel {
        id: groupProxyModel
    }
}
