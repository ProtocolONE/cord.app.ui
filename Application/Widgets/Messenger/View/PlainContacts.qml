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

import "../../../../GameNet/Core/lodash.js" as Lodash

import "../Models/Messenger.js" as Messenger
import "../Models/Jobs.js" as Jobs

import "./PlainContacts.js" as Js

Rectangle {
    id: root

    color: "#FFBCB2"

    QtObject {
        id: d

        property bool group1Opened: false

        function updateModel() {
            var start = +(new Date());
            var groupIds = Messenger.groups().keys();

            Lodash._.difference(groupIds, Object.keys(Js.groupsMap)).forEach(function(groupId) {
                if (Messenger.isGamenetGroup(groupId)) {
                    return;
                }

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

                });
            });



            var end = +(new Date());
            console.log('Update time : ', end - start, 'ms');

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

            var qq = { t: 0 };
            // HACK для тестов догрузки пользователей
            if (groupId == "Combat Arms (CA)") {
                users = Lodash._.remove(users, function (item, index) {
                    this.t++;
                    return this.t % 2 == 1;
                }, qq);
            }




            var insertIndex = Js.calculateInsertIndex(groupId);

            var group = Js.groupById(groupId);
            group.users = users.slice(0);

            Js.setGroupOpened(groupId, true);
            Js.removeItemJob(insertIndex, 1);
            Js.appendAllJob(insertIndex, groupId, users);
        }

        function closeGroup(groupId) {
            if (Js.jobInProgress()) {
                return;
            }

            var ind = Js.calculateInsertIndex(groupId);

            Js.setGroupOpened(groupId, false);
            var group = Js.groupById(groupId);
            var usersLen = group.users.length;
            Js.removeItemJob(ind, usersLen);
            Js.appendGroupItem(ind, groupId)
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

        function appendAll2(job) {
            var i, batchSize = job.second ? 1000 : 30;
            job.second = 1;

            var users = job.users.slice(0, batchSize);
            var group = Js.groupById(job.groupId);
            var startIndex = Js.calculateInsertIndex(job.groupId);
            var user,
                item;

            for (i in users) {
                user = users[i];
                group.users.push(user)

                item = {
                    isGroupItem: false,
                    value: user,
                    sectionId: job.groupId
                 };

                d.groupModelInsert(group.users.length + startIndex - 1, item);
            }

            job.users.splice(0, batchSize);
            if (job.users.length === 0) {
                Js.popJob();
            }
        }

        function appendAll(job) {
            var i, batchSize = job.second ? 1000 : 30;
            job.second = 1;

            if (!job.currentIndex) {
                job.currentIndex = job.index;
            }

            var users = job.users.slice(0, batchSize);
            var user,
                item;

            for (i in users) {
                user = users[i];

                item = {
                    isGroupItem: false,
                    value: user,
                    sectionId: job.groupId
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
                Js.popJob();
            }
        }

        function appendGroup(job) {
            d.groupModelInsert(job.index, {
                                   isGroupItem: true,
                                   value: job.groupId,
                                   sectionId: ""
                               });
            Js.popJob();
        }

        function groupModelInsert(index, item) {
//            if (index < 0 || index > groupProxyModel.count) {
//                throw new Error('Group proxy model insert out of range. Index: ' + index + ' Count: ' + groupProxyModel.count);
//            }

            groupProxyModel.insert(index, item);
        }

        function groupModelRemove(index) {
//            if (index < 0 || index >= groupProxyModel.count) {
//                throw new Error('Group proxy model remove out of range. Index: ' + index + ' Count: ' + groupProxyModel.count);
//            }

            groupProxyModel.remove(index);
        }
    }

    Timer {
        id: consumer

        interval: 5
        running: true
        repeat: true
        onTriggered: {
            d.doJob();
        }
    }

    Connections {
        target: Messenger.groups()
        onSourceChanged: {
            console.log('groups model source changed');
            d.updateModel();
        }
    }

    Connections {
        target: Messenger.users()
        onSourceChanged: {
            console.log('users model source changed');
            d.updateModel();
        }
    }

    ListView {
        id: listView

        //model: fakeGroupModel
        model: groupProxyModel
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds

        clip: true
        section.property: "sectionId"
        section.delegate: Rectangle {
            width: listView.width
            height: visible ? 33 : 0
            color: "cyan"
            visible: !!section

            Text {
                color: "#000000"
                anchors.centerIn: parent
                text: section +  ((!!section) ? (" (" + Messenger.groups().getById(section).users.count + ")") : " empty")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log('Section clicked' + section);
                    d.closeGroup(section)
                }
            }
        }

        delegate: Item {
            width: listView.width
            height: (model.isGroupItem ? 33 : 53)

            Rectangle {
                anchors.fill: parent
                visible: model.isGroupItem
                color: "#7A7CFF"

                Text {
                    anchors.centerIn: parent
                    color: "#000000"
                    text: model.isGroupItem
                          ? (model.value + (model.value ? (" (" + Messenger.groups().getById(model.value).users.count + ")") : ""))
                          : ""
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: d.openGroup(model.value, index);
                }
            }

            ContactItem {
                anchors.fill: parent
                visible: !model.isGroupItem
                nickname: Messenger.getNickname({jid: model.value})
                avatar: Messenger.userAvatar({jid: model.value})
                onClicked: {
                    Messenger.selectUser({jid: model.value}, {groupId: model.sectionId})
                }
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#FFFFFF"
                anchors.top: parent.top
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#E5E5E5"
                anchors.bottom: parent.bottom
            }

        }
    }


    ListViewScrollBar {
        anchors.left: listView.right
        height: listView.height
        width: 16
        listView: listView
        cursorMaxHeight: 100
    }


    ListModel {
        id: groupProxyModel
    }

    ListModel {
        id: fakeGroupModel

        ListElement {
            isGroupItem: true
            value: "Group0"
            sectionId: ""
        }

        ListElement {
            isGroupItem: true
            value: "Group01"
            sectionId: ""
        }

        ListElement {
            isGroupItem: true
            value: "Group02"
            sectionId: ""
        }

        ListElement {
            isGroupItem: false
            value: "Test1"
            sectionId: "Group1"
        }

        ListElement {
            isGroupItem: false
            value: "Test1"
            sectionId: "Group2"
        }

        ListElement {
            isGroupItem: false
            value: "Test2"
            sectionId: "Group2"
        }

        ListElement {
            isGroupItem: false
            value: "Test1"
            sectionId: "Group3"
        }

        ListElement {
            isGroupItem: false
            value: "Test2"
            sectionId: "Group3"
        }

        ListElement {
            isGroupItem: false
            value: "Test3"
            sectionId: "Group3"
        }
    }

}

