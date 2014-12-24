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
import "../../../../../Application/Core/moment.js" as Moment

import "../../../../Core/Styles.js" as Styles

import "../User.js" as User

import "./RecentConversation.js" as Js

Item {
    id: root

    signal dataChanged()

    property variant messenger

    property int unreadContactCount: d.calcUnreadContactCount()
    property bool unreadGameNetMessages: d.hasUnreadGameNetMessages()
    property alias proxyModel: proxyModel

    function sectionCaption(date) {
        return d.sectionCaption(date);
    }

    QtObject {
        id: d

        property string today: ""
        property string yesterday: ""

        function updateModel() {
            var usersMap = {}
                , users = []
                , i
                , usersToInsert
                , usersToRemove;

            d.build(usersMap, users);

            if (users.length === 0) {
                Js.sortedUsers = [];
                proxyModel.clear();
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

        function build(usersMap, users) {
            var usersModel = messenger.getUsersModel()
                , i
                , jid
                , modelUser
                , lastTalkDate
                , now = Moment.moment()
                , longAgo = Moment.moment().subtract('days', 7)
                , last;

            for (i = 0; i < usersModel.count; ++i) {
                modelUser = usersModel.get(i)
                lastTalkDate = modelUser.lastTalkDate || 0;
                if (lastTalkDate == 0 || User.isGameNet(modelUser)) {
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

            if (User.isGameNet(user)) {
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

        function hasUnreadGameNetMessages() {
            if (!messenger) {
                return false;
            }

            // HACK: значение нужно для биндинга, но фактически не используется
            var count = proxyModel.count;

            var gameNetUser = messenger.getGamenetUser();
            if (gameNetUser) {
                return gameNetUser.unreadMessageCount > 0;
            }

            return false;
        }
    }

    Connections {
        target: messenger.getGroupsModel()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: messenger.getUsersModel()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: messenger
        onTalkDateChanged: d.talkDateChanged(jid);
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
