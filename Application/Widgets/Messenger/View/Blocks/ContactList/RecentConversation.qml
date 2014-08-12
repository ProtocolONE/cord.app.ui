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
import "../../../../../../Application/Core/moment.js" as Moment

import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as Messenger
import "../../../Models/User.js" as User

import "./RecentConversation.js" as Js;

Item {
    id: root

    property int unreadContactCount: d.calcUnreadContactCount()

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

                    if (val1 === val2) {
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
            var usersModel = Messenger.users()
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
                if (lastTalkDate === 0 || User.isGameNet(modelUser)) {
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
                userTime = Moment.moment(Messenger.getUser(proxyModel.get(i).jid).lastTalkDate);
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
                    return u === deletedUser;
                });

                Js.sortedUsers.splice(deleteIndex, 1);
                proxyModel.remove(deleteIndex);
            });
        }

        function talkDateChanged(userId) {
            var user = Messenger.getUser(userId);

            if (User.isGameNet(user)) {
                return;
            }

            var actualDate = Moment.moment(user.lastTalkDate).format('DD.MM.YYYY');

            var index = Lodash._.findIndex(Js.sortedUsers, function(u) {
                return u === userId;
            });

            if (-1 !== index && proxyModel.get(index).date === actualDate) {
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

            scrollbar.positionViewAtBeginning();
        }

        function calcUnreadContactCount() {
            var result = 0, i;
            for (i = 0; i < proxyModel.count; ++i) {
                if (Messenger.hasUnreadMessages(proxyModel.get(i))) {
                    result += 1;
                }
            }

            return result;
        }
    }

    Connections {
        target: Messenger.groups()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: Messenger.users()
        onSourceChanged: d.updateModel();
    }

    Connections {
        target: Messenger.instance()
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

    ListView {
        id: listView

        model: proxyModel
        anchors {
            fill: parent
            rightMargin: 10
        }

        boundsBehavior: Flickable.StopAtBounds
        clip: true

        section.property: "sectionId"
        section.delegate: RecentDateHeader {
            width: listView.width
            height: 33
            caption: d.sectionCaption(section)
        }

        delegate: ContactItemDelegate {
            width: listView.width
            height: 53
            user: model
            group: model
            onClicked: select();
        }
    }

    Text {

        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        visible: proxyModel.count === 0

        text: qsTr("MESSENGER_RECENT_CONTACTS_EMPTY_INFO")
        wrapMode: Text.Wrap
        color: Styles.style.messengerRecentContactEmptyInfo
        font {
            family: "Arial"
            pixelSize: 14
            bold: false
        }
    }

    ListViewScrollBar {
        id: scrollbar

        anchors.left: listView.right
        height: listView.height
        width: 10
        listView: listView
        cursorMaxHeight: listView.height
        cursorMinHeight: 50
        color: Styles.style.messangerContactScrollBar
        cursorColor: Styles.style.messangerContactScrollBarCursor
    }

    ListModel {
        id: proxyModel
    }
}
