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
import GameNet.Components.JobWorker 1.0

import Application.Controls 1.0

import "../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../../Core/Styles.js" as Styles


import "../User.js" as User

import "./AllContacts.js" as Js

Item {
    id: root

    property variant messenger
    property alias model: proxyModel

    QtObject {
        id: d

        function updateModel() {
            var usersMap = {}
                , users = []
                , i
                , usersToInsert
                , usersToRemove;
            d.build(usersMap, users);

            if (users.length === 0) {
                d.clearModel();
                return;
            }

            if (Js.sortedUsers.length === 0) {
                d.fillEmptyModel(usersMap, users);
                return;
            }

            usersToInsert = Lodash._.difference(users, Js.sortedUsers);
            usersToRemove = Lodash._.difference(Js.sortedUsers, users);

            d.removeUsers(usersToRemove);
            d.insertUsers(usersToInsert, usersMap);
        }

        function updateUserOrderPosition(jid) {
            var usersMap = {}
                , users = []
                , currentIndex
                , insertIndex;

            d.build(usersMap, users);
            currentIndex = d.findUser(jid);

            if (currentIndex < 0) {
                return;
            }

            Js.sortedUsers.splice(currentIndex, 1);
            insertIndex = d.findInsertIndex(usersMap, jid);
            insertIndex = insertIndex >= 0 ? insertIndex : Js.sortedUsers.length;
            Js.sortedUsers.splice(insertIndex, 0, jid);

            if (currentIndex !== insertIndex) {
                worker.push(new Js.MoveItemJob({
                                                   model: proxyModel,
                                                   fromIndex: currentIndex,
                                                   toIndex: insertIndex
                                               }));
            }
        }

        function build(usersMap, users) {
            var usersModel = root.messenger.getUsersModel()
                , i
                , jid
                , modelUser;

            for (i = 0; i < usersModel.count; ++i) {
                modelUser = usersModel.get(i);
                if (User.isGameNet(modelUser)) {
                    continue;
                }

                jid = modelUser.jid;

                usersMap[jid] = {
                    online: User.isOnline(modelUser.presenceState),
                    nickname: modelUser.nickname.toLowerCase(),
                    lastActivity: messenger.getUser(jid).lastActivity
                };

                users.push(jid);
            }
        }

        function clearModel() {
            worker.clear();
            Js.sortedUsers = [];
            proxyModel.clear();
        }

        function fillEmptyModel(usersMap, users) {
            users.sort(function(a,b) {
                return d.usersSortFunction(usersMap, a, b)
            });

            Js.sortedUsers = users.slice();
            worker.push(new Js.InsertUsers({
                                               model: proxyModel,
                                               index: 0,
                                               users: users
                                           }));
        }

        function usersSortFunction(usersMap, a, b) {
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
        }

        function removeUsers(users) {
            users.forEach(d.removeUser);
        }

        function removeUser(deletedUser) {
            var deleteIndex = d.findUser(deletedUser);
            if (deleteIndex === -1) {
                return;
            }

            Js.sortedUsers.splice(deleteIndex, 1);
            worker.push(new Js.RemoveItemJob({
                                               model: proxyModel,
                                               index: deleteIndex,
                                               count: 1
                                           }));
        }

        function insertUsers(users, usersMap) {
            users.forEach(function(newUser) {
                var index = d.findInsertIndex(usersMap, newUser);
                Js.sortedUsers.splice(index, 0, newUser);

                worker.push(new Js.InsertUsers({
                                                   model: proxyModel,
                                                   index: index,
                                                   users: [newUser]
                                               }));
            });
        }

        function findUser(jid) {
            return Lodash._.findIndex(Js.sortedUsers, function(u) {
                return u === jid;
            })
        }

        function findInsertIndex(usersMap, jid) {
            var index;
            index = Lodash._.findIndex(Js.sortedUsers, function(u) {
                return usersSortFunction(usersMap, jid, u) < 0;
            });

            return index >= 0 ? index : Js.sortedUsers.length;
        }
    }

    JobWorker {
        id: worker

        interval: 5
        managed: true
    }

    Connections {
        target: messenger
        onOnlineStatusChanged: d.updateUserOrderPosition(jid);
        onLastActivityChanged: d.updateUserOrderPosition(jid);
        onNicknameChanged: d.updateUserOrderPosition(jid);
    }

    Connections {
        target: messenger.getUsersModel()
        onSourceChanged: d.updateModel();
    }

    ListModel {
        id: proxyModel
    }

}
