import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Controls 1.0
import Application.Core 1.0

import "../User.js" as UserJs

import "./RecentConversation.js" as Js

Item {
    id: root

    signal dataChanged()

    property variant messenger
    property bool pauseProcessing

    property int unreadContactCount: d.calcUnreadContactCount()
    property bool unreadProtocolOneMessages: d.hasUnreadProtocolOneMessages()
    property alias proxyModel: proxyModel
    property alias count: proxyModel.count

    function sectionCaption(date) {
        return d.sectionCaption(date);
    }

    function reset() {
        d.clearModel();
    }

    function update() {
        d.updateModel();
    }

    QtObject {
        id: d

        property string today: ""
        property string yesterday: ""

        function clearModel() {
            Js.sortedUsers = [];
            proxyModel.clear();
        }

        function updateModel(jids) {
            var usersMap = {}
                , users = []
                , i
                , usersToInsert
                , usersToRemove;

            d.build(usersMap, users, jids);

            if (users.length === 0) {
                d.clearModel()
                return;
            }

            if (Js.sortedUsers.length == 0) {
                users.sort(function(a, b) {
                    var val1 = usersMap[a].lastTalkDate;
                    var val2 = usersMap[b].lastTalkDate;

                    if (val1 == val2) {
                        return 0;
                    }

                    if (val1 < val2) {
                        return 1;
                    }

                    return -1;
                });

                for (i = 0; i < users.length; i++) {
                    var user = users[i];
                    proxyModel.append({
                                          sectionId: usersMap[user].date,
                                          jid: user
                                      });
                }

                Js.sortedUsers = users;

            } else {
                usersToInsert = Lodash._.difference(users, Js.sortedUsers);
                usersToRemove = Lodash._.difference(Js.sortedUsers, users);
                d.insertUsers(usersToInsert, usersMap);
                d.removeUsers(usersToRemove);
            }
        }

        function build(usersMap, users, keys) {
            var usersModel = messenger.getUsersModel()
                , i
                , jid
                , modelUser
                , lastTalkDate
                , now = Moment.moment()
                , longAgo = Moment.moment().subtract('days', 7)
                , last;

            keys = keys || usersModel.keys();

            for (i in keys) {
                jid = keys[i];
                modelUser = usersModel.get(jid);

                if (!modelUser) {
                    continue;
                }

                lastTalkDate = modelUser.lastTalkDate || 0;
                if (lastTalkDate == 0 || UserJs.isProtocolOne(modelUser)) {
                    continue;
                }

                if (messenger.isUserBlocked(modelUser)) {
                    continue;
                }

                last = Moment.moment(lastTalkDate);
                jid = modelUser.jid;

                usersMap[jid] = {
                    lastTalkDate: lastTalkDate,
                    date: (now.diff(last, 'days') > 7 ? 'LongAgo' : last.format('DD.MM.YYYY'))
                };

                users.push(jid);
            }
        }

        function updateToday() {
            var now = Moment.moment().format('DD.MM.YYYY');
            if (now === d.today) {
                return;
            }

            var nextTick = Moment.moment().endOf('day').diff(Moment.moment())+1;
            refreshDateTimer.interval = nextTick;

            var i
                , user
                , userTime;

            d.yesterday = d.today || Moment.moment().subtract('days', 1).format('DD.MM.YYYY');
            d.today = now;

            for (i = 0; i < proxyModel.count; ++i) {
                userTime = Moment.moment(messenger.getUser(proxyModel.get(i).jid).lastTalkDate);
                if (Moment.moment().diff(userTime, 'days') > 6) {
                    proxyModel.setProperty(i, 'sectionId', 'LongAgo');
                }
            }
        }

        function sectionCaption(date) {
            if (date === d.today) {
                return qsTr("RECENTCONVERSATION_TODAY");
            }

            if (date === d.yesterday) {
                return qsTr("RECENTCONVERSATION_YESTERDAY");
            }

            if (date === "LongAgo") {
                return qsTr("RECENTCONVERSATION_LONGAGO");
            }

            return date;
        }

        function insertUsers(users, usersMap) {
            users.forEach(function(newUser) {
                var index
                    , userDate = usersMap[newUser].lastTalkDate;

                index = Lodash._.findIndex(Js.sortedUsers, function(u) {
                    return usersMap[u].lastTalkDate < userDate;
                });

                if (index === -1) {
                    index = Js.sortedUsers.length;
                }

                Js.sortedUsers.splice(index, 0, newUser);
                proxyModel.insert(index, {
                                      sectionId: usersMap[newUser].date,
                                      jid: newUser
                                  });
            });
        }

        function removeUsers(users, usersMap) {
            users.forEach(function(deletedUser) {
                var deleteIndex = Lodash._.findIndex(Js.sortedUsers, function(u) {
                    return u == deletedUser;
                });

                Js.sortedUsers.splice(deleteIndex, 1);
                proxyModel.remove(deleteIndex);
            });
        }

        function talkDateChanged(userId) {
            var user = messenger.getUser(userId);

            if (UserJs.isProtocolOne(user)) {
                return;
            }

            var actualDate = Moment.moment(user.lastTalkDate).format('DD.MM.YYYY');

            var index = Lodash._.findIndex(Js.sortedUsers, function(u) {
                return u === userId;
            });

            if (-1 !== index && proxyModel.get(index).date == actualDate) {
                return;
            }

            Js.sortedUsers.splice(0, 0, userId);

            if (index !== -1) {
                Js.sortedUsers.splice(index, 1);
                proxyModel.setProperty(index, 'sectionId', actualDate);
                proxyModel.move(index, 0, 1);
            } else {
                proxyModel.insert(0, {
                                      sectionId: actualDate,
                                      jid: userId
                                  });
            }

            root.dataChanged();
        }

        function calcUnreadContactCount() {
            var result = 0, i;

            for (i = 0; i < proxyModel.count; ++i) {
                if (messenger.hasUnreadMessages(proxyModel.get(i))) {
                    result += 1;
                }
            }

            return result;
        }

        function hasUnreadProtocolOneMessages() {
            if (!messenger) {
                return false;
            }

            // HACK: значение нужно для биндинга, но фактически не используется
            var count = proxyModel.count;

            var ProtocolOneUser = messenger.getProtocolOneUser();
            if (protocolOneUser) {
                return protocolOneUser.unreadMessageCount > 0;
            }

            return false;
        }
    }

    function getUsers() {
        return Js.sortedUsers.slice();
    }

    Connections {
        target: messenger.getUsersModel()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: messenger
        onTalkDateChanged: d.talkDateChanged(jid);
        onRecentConversationsReady: {
            jids.forEach(function(e) {
                //INFO Force to add user in user list
                messenger.getUser(e);
            });

            d.updateModel(jids);
        }
    }

    Timer {
        id: refreshDateTimer

        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: d.updateToday();
    }

    ListModel {
        id: proxyModel
    }
}
