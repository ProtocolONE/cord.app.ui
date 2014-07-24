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

import "../../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../Models/Messenger.js" as Messenger

import "./PlainContacts.js" as Js

Item {
    id: root

    QtObject {
        id: d

        property bool group1Opened: false

        function updateModel() {
            var groupIds = Messenger.groups().keys();

            Lodash._.difference(groupIds, Object.keys(Js.groupsMap)).forEach(function(groupId) {
                var itemCount = Js.itemCount();
                var index = Js.appendGroup(groupId);
                if (index === -1) {
                    index = itemCount;
                }

                Js.appendGroupItem(index, groupId);
            });

            Lodash._.difference(Object.keys(Js.groupsMap), groupIds).forEach(function(groupId) {
                var remvoeGroupIndex = Js.calculateInsertIndex(groupId);
                var itemCount = Js.isOpened(groupId) ? Js.groupById(groupId).users.length : 1;

                Js.removeItemJob(remvoeGroupIndex, itemCount);
                Js.removeGroup(groupId);
            });


            d.updateOpenedGroups();
        }

        function updateOpenedGroups() {
            var usersModel = Messenger.users();

            var openedGroups = Object.keys(Js.groupsMap).filter(function(g) { return Js.isOpened(g); });
            openedGroups.forEach(function(openedId) {
                var currentUsers = Js.groupById(openedId).users;

                var actualUserModel = Messenger.groups().getById(openedId).users;
                var actualUsers = [];
                var actualUsersMap = {};
                var i;
                for (i = 0; i < actualUserModel.count; ++i) {
                    var modelUser = actualUserModel.get(i)
                    var jid = modelUser.jid;
                    actualUsersMap[jid] = usersModel.getById(jid).nickname.toLowerCase();
                    actualUsers.push(jid);
                }

                var groupStartIndex = Js.calculateInsertIndex(openedId);

                Lodash._.difference(actualUsers, currentUsers).forEach(function(newUser) {
                    var newUserNickName = Messenger.users().getById(newUser).nickname.toLowerCase();
                    var newUserInsertIndex = Lodash._.findIndex(currentUsers, function(u) {
                        return actualUsersMap[u] > newUserNickName;
                    });

                    newUserInsertIndex = newUserInsertIndex > 0 ? newUserInsertIndex : currentUsers.length;
                    currentUsers.splice(newUserInsertIndex, 0, newUser);
                    Js.appendAllJob(groupStartIndex + newUserInsertIndex, openedId, [newUser]);
                });

                Lodash._.difference(currentUsers, actualUsers).forEach(function(deletedUser) {
                    var deleteIndex = Lodash._.findIndex(currentUsers, function(u) {
                        return u === deletedUser;
                    });

                    currentUsers.splice(deleteIndex, 1);
                    Js.removeItemJob(groupStartIndex + deleteIndex, 1);
                });
            });

        }

        function openGroup(groupId, index) {
            if (Js.jobInProgress()) {
                return;
            }

            var groupUsersModel = Messenger.groups().getById(groupId).users;
            var users = [];
            var usersMap = {};
            var usersModel = Messenger.users();
            var i;

            for (i = 0; i < groupUsersModel.count; ++i) {
                var modelUser = groupUsersModel.get(i)
                var jid = modelUser.jid;
                users.push(jid);
                usersMap[jid] = usersModel.getById(jid).nickname.toLowerCase();
            }

            users.sort(function(a, b) {
                var val1 = usersMap[a];
                var val2 = usersMap[b];

                if (val1 === val2) {
                    return 0;
                }

                if (val1 < val2) {
                    return -1;
                }

                return 1;
            });

            var insertIndex = Js.calculateInsertIndex(groupId);

            var group = Js.groupById(groupId);
            group.users = users.slice(0);

            Js.setGroupOpened(groupId, true);
            Js.appendAllJob(insertIndex, groupId, users, true);
        }

        function closeGroup(groupId) {
            if (Js.jobInProgress()) {
                return;
            }

            var ind = Js.calculateInsertIndex(groupId);

            Js.setGroupOpened(groupId, false);
            var group = Js.groupById(groupId);
            var usersLen = group.users.length;
            Js.removeItemJob(ind, usersLen, groupId);
            Js.groupsMap[groupId].users = [];
        }

        function doJob() {
            var job = Js.currentJob();
            if (!job) {
                return;
            }

            if (job.action === "appendAll") {
                d.appendAll(job);
            }

            if (job.action === "remove") {
                d.remove(job)
            }

            if (job.action === "appendGroup") {
                d.appendGroup(job)
            }
        }

        function appendAll(job) {
            var i, batchSize = job.second ? 1000 : 30;
            job.second = 1;

            if (!job.currentIndex) {
                job.currentIndex = job.index;
            }

            if (job.removeHeader) {
                d.groupModelRemove(job.index);
                job.removeHeader = false;
            }

            var users = job.users.slice(0, batchSize);
            var user,
                    item;

            for (i in users) {
                user = users[i];

                item = {
                    isGroupItem: false,
                    value: user,
                    sectionId: job.groupId,
                    groupId: job.groupId,
                    jid: user
                };

                d.groupModelInsert(job.currentIndex, item);
                job.currentIndex++;
            }

            job.users.splice(0, batchSize);
            if (job.users.length === 0) {
                Js.popJob();
            }
        }

        function remove(job) {
            var batchSize = 500;
            var b = Math.min(batchSize, job.count);

            for (var i = 0; i < b; i++) {
                d.groupModelRemove(job.index + job.count - 1 - i);
            }

            job.count -= b;

            if (job.count <= 0) {
                if (job.appendGroupId) {
                    d.groupModelInsert(job.index, {
                                           isGroupItem: true,
                                           value: job.appendGroupId,
                                           sectionId: "",
                                           groupId: job.appendGroupId,
                                           jid: ""
                                       });
                }

                Js.popJob();
            }
        }

        function appendGroup(job) {
            d.groupModelInsert(job.index, {
                                   isGroupItem: true,
                                   value: job.groupId,
                                   sectionId: "",
                                   groupId: job.groupId,
                                   jid: ""
                               });
            Js.popJob();
        }

        function groupModelInsert(index, item) {
            groupProxyModel.insert(index, item);
        }

        function groupModelRemove(index) {
            groupProxyModel.remove(index);
        }

        function userCount(groupId) {
            return Messenger.groups().getById(groupId).users.count;
        }

        function countUnreadUsers(groupId) {
            var users = Messenger.groups().getById(groupId).users,
                    count = users.count,
                    i,
                    result = 0;

            for (i = 0; i < count; ++i) {
                if (Messenger.hasUnreadMessages(users.get(i))) {
                    result += 1;
                }
            }

            return result;
        }
    }

    Timer {
        interval: 5
        running: true
        repeat: true
        onTriggered: d.doJob();
    }

    Connections {
        target: Messenger.groups()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: Messenger.users()
        onSourceChanged: d.updateModel();
    }

    ListView {
        id: listView

        model: groupProxyModel
        anchors {
            fill: parent
            rightMargin: 10
        }

        boundsBehavior: Flickable.StopAtBounds

        clip: true
        section.property: "sectionId"
        section.delegate: GroupHeader {
            width: listView.width
            height: visible ? 33 : 0
            visible: !!section
            opened: true
            groupName: section
            usersCount: section ? d.userCount(section) : 0
            onClicked: d.closeGroup(section)
        }

        delegate: Item {
            width: listView.width
            height: (model.isGroupItem ? 33 : 53)

            GroupHeader {
                width: listView.width
                height: 33
                visible: model.isGroupItem
                opened: false
                groupName: model.value
                usersCount: model.isGroupItem ? d.userCount(model.value) : 0
                onClicked: d.openGroup(model.value, index)
                unreadUsersCount: model.isGroupItem ? d.countUnreadUsers(model.value) : 0
            }

            ContactItem {
                anchors.fill: parent
                visible: !model.isGroupItem
                nickname: model.isGroupItem ? "" : Messenger.getNickname(model)
                avatar: model.isGroupItem ? "" : Messenger.userAvatar(model)
                isUnreadMessages: model.isGroupItem ? false : (!isCurrent && Messenger.hasUnreadMessages(model));
                isCurrent: model.isGroupItem ? false : Messenger.isSelectedUser(model) && Messenger.isSelectedGroup(model)
                onClicked: Messenger.selectUser(model, model);
            }
        }
    }


    ListViewScrollBar {
        anchors.left: listView.right
        height: listView.height
        width: 10
        listView: listView
        cursorMaxHeight: 100
    }

    ListModel {
        id: groupProxyModel
    }
}

