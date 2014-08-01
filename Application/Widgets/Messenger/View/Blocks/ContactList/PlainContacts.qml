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
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger

import "./PlainContacts.js" as Js

Item {
    id: root

    QtObject {
        id: d

        function updateModel() {
            var groupIds = Messenger.groups().keys()
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
            Object.keys(Js.groupsMap).filter(function(g) {
                return Js.isOpened(g);
            }).forEach(function(openedId) {
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
            var usersModel = Messenger.users()
                , actualUserModel = Messenger.groups().getById(openedId).users
                , modelUser
                , jid
                , i;

            for (i = 0; i < actualUserModel.count; ++i) {
                modelUser = actualUserModel.get(i)
                jid = modelUser.jid;
                actualUsersMap[jid] = usersModel.getById(jid).nickname.toLowerCase();
                actualUsers.push(jid);
            }
        }

        function insertUsersToOpenedGroup(users, currentUsers, groupStartIndex, openedId) {
            users.forEach(function(newUser) {
                var newUserNickName,
                    newUserInsertIndex;

                newUserNickName = Messenger.users().getById(newUser).nickname.toLowerCase();
                newUserInsertIndex = Lodash._.findIndex(currentUsers, function(u) {
                    return actualUsersMap[u] > newUserNickName;
                });

                newUserInsertIndex = newUserInsertIndex > 0 ? newUserInsertIndex : currentUsers.length;
                currentUsers.splice(newUserInsertIndex, 0, newUser);
                Js.queueAppendAllJob(groupStartIndex + newUserInsertIndex, openedId, [newUser]);
            });
        }

        function removeFromOpenedGroup(users, currentUsers, groupStartIndex) {
            users.forEach(function(deletedUser) {
                var deleteIndex = Lodash._.findIndex(currentUsers, function(u) {
                    return u === deletedUser;
                });

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
            var group = Messenger.groups().getById(groupId);
            if (!group) {
                return 0;
            }

            return group.users.count;
        }

        function countUnreadUsers(groupId) {
            var group = Messenger.groups().getById(groupId);

            if (!group) {
                return 0;
            }

            var users = group.users,
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
        onTriggered: Js.processJob(groupProxyModel);
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
            groupName: Messenger.getGroupName({groupId: section})
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
                groupName: Messenger.getGroupName(model)
                usersCount: model.isGroupItem ? d.userCount(model.value) : 0
                onClicked: d.openGroup(model.value, index)
                unreadUsersCount: model.isGroupItem ? d.countUnreadUsers(model.value) : 0
            }

            ContactItemDelegate {
                anchors.fill: parent
                visible: !model.isGroupItem
                user: model
                group: model
                onClicked: select();
            }
        }
    }

    ListViewScrollBar {
        anchors.left: listView.right
        height: listView.height
        width: 10
        listView: listView
        cursorMaxHeight: listView.height
        cursorMinHeight: 50
        color: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor);
        cursorColor: Qt.darker(Styles.style.messengerContactsBackground, Styles.style.darkerFactor * 1.5);
    }

    ListModel {
        id: groupProxyModel
    }
}

