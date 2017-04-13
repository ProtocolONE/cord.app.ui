/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

import "./Blocks"

WidgetView {
    id: root

    visible: d.opened

    implicitWidth: visible ? 353: 0
    implicitHeight: parent.height

    function isOpened() {
        return d.opened;
    }

    QtObject {
        id: d

        property string imageRoot: installPath + "Assets/Images/Application/Widgets/DetailedUserInfo/"

        property string targetUserId: ""
        property string targetNickname: ""
        property bool targetIsFriend: false
        property bool targetIsFriendRequestSended: false

        property string status: ""

        property bool loading: true
        property bool opened: false
        property bool isError: false
        property string errorMessage: "Fail"

        property string nickname: ""

        function open(opt) {
            var userId = opt.userId;

            d.loading = true;
            d.isError = false;
            d.opened = true;

            d.targetUserId = userId;

            d.targetNickname = opt.nickname || "";
            d.status = opt.status || "";
            d.targetIsFriend = opt.hasOwnProperty('isFriend') ? opt.isFriend : true;
            d.targetIsFriendRequestSended = opt.hasOwnProperty('isSended') ? opt.isSended : true;

            if (!userId) {
                d.setError();
                return;
            }

            mainInfoItem.progress = 0;
            mainInfoItem.progressBar = 0;

            RestApi.Core.execute('user.getProfile',
                                 {
                                     profileId: userId,
                                     shortInfo: 1,
                                     achievements: 1,
                                     personalInfo: 1,
                                     playedGames: 1
                                 },
                                 true, d.parseProfile, function(err) {
                                     d.setError();
                                 });
        }

        function close() {
            d.opened = false;
            d.targetUserId = "";
        }

        function parseProfile(response) {
            var userInfo;
            if (response.error) {
                d.setError();
                return;
            }

            if (!Array.isArray(response.userInfo) || response.userInfo.length < 1) {
                d.setError();
                return;
            }

            var rawUserInfo = response.userInfo[0];

            userInfo = {};
            userInfo.shortInfo = Lodash._.assign({
                                                     nickname: "",
                                                     nametech: "",
                                                     avatarLarge: ""
                                                 }, rawUserInfo.shortInfo);

            userInfo.personalInfo = Lodash._.assign({
                                                        firstname: "",
                                                        lastname: ""
                                                    }, rawUserInfo.personalInfo);

            userInfo.experience = Lodash._.assign({
                                                      level: 1,
                                                      rating: 65535,
                                                      progress: 0,
                                                      prevLevelExp: 0,
                                                      nextLevelExp: 0,
                                                      countAchievements: 0
                                                  }, rawUserInfo.experience);

            userInfo.achievements = Lodash._.assign([], rawUserInfo.achievements);

            userInfo.games = Lodash._.assign({
                                                 playingGames: [],
                                                 lastPlayList: []
                                             }, rawUserInfo.games);

            d.nickname = userInfo.shortInfo.nickname;

            d.clearGames(userInfo);
            d.fillMainInfo(userInfo);

            gameInfoItem.update(d.targetUserId)
        }

        function toNumber(i) {
            return i | 0;
        }

        function clearGames(userInfo) {
            gameInfoItem.playingGames = userInfo.games.playingGames
                .filter(App.gameExists)
                .map(d.toNumber);

            gameInfoItem.lastPlayList = userInfo.games.lastPlayList
                .reduce(function(a, g) {
                    if (App.gameExists(g.gameId)) {
                        a.push({
                                   gameId: g.gameId | 0,
                                   time: g.time | 0
                               });
                    }

                    return a;
                }, []);
        }

        function parseCharsFinished() {
            showAnimation.restart()
            d.loading = false;
        }

        function fillMainInfo(userInfo) {
            mainInfoItem.avatar = userInfo.shortInfo.avatarLarge;
            mainInfoItem.nametech = userInfo.shortInfo.nametech;

            mainInfoItem.fio = d.getFIO(userInfo) || userInfo.shortInfo.nickname || d.targetNickname || d.targetUserId;
            mainInfoItem.subInfo1 = d.getSubInfo1(userInfo);
            mainInfoItem.subInfo2 = d.getSubInfo2(userInfo);

            d.parseAchievments(userInfo)

            mainInfoItem.level = userInfo.experience.level;
            mainInfoItem.rating = userInfo.experience.rating;

            mainInfoItem.progress = d.getProgess(userInfo);
            mainInfoItem.targetId = d.targetUserId;
            mainInfoItem.currentExp = userInfo.experience.progress;
            mainInfoItem.nextExp = userInfo.experience.nextLevelExp;

            mainInfoItem.setFriendshipStatus(d.targetIsFriend, d.targetIsFriendRequestSended);
        }

        function getFIO(userInfo) {
            return (userInfo.personalInfo.firstname + " " +  userInfo.personalInfo.lastname).trim();
        }

        function getSubInfo1(userInfo) {
            var tmp = [], birthday, age;

            if (userInfo.personalInfo.birthday) {
                birthday = Moment.moment(userInfo.personalInfo.birthday, "DD-MM-YYYY");
                if (birthday.isValid()) {
                    tmp.push(Moment.moment.duration(Moment.moment().diff(birthday, 'years'), 'years').humanize());
                }
            }

            if (userInfo.personalInfo.country) {
                tmp.push(userInfo.personalInfo.country)
            }

            if (userInfo.personalInfo.city) {
                tmp.push(userInfo.personalInfo.city)
            }

            return tmp.join(', ');
        }

        function getSubInfo2(userInfo) {
            var registerDate;

            registerDate = Moment.moment(userInfo.shortInfo.registerDate, "DD.MM.YYYY");
            if (!registerDate.isValid()) {
                return "";
            }

            return qsTr("DETAILED_USER_INFO_MAIN_INFO_IN_GAMENET_SINCE").arg(registerDate.format('DD MMMM YYYY'));
        }

        function parseAchievments(userInfo) {
            mainInfoItem.countAchievements = userInfo.experience.countAchievements | 0;
            mainInfoItem.clearAchievment();

            userInfo.achievements.forEach(function(a) {
                mainInfoItem.appendAchievment({
                                                  source: Config.GnUrl.site(("/images/achievements/%1%2.png").arg(a.name).arg(a.level)),
                                                  title: a.title,
                                                  description: a.description,
                                                  level: a.level
                                              });
            });
        }

        function getProgess(userInfo) {
            var expirence = userInfo.experience, current, next, prev, result;

            current = userInfo.experience.progress | 0;
            next = userInfo.experience.nextLevelExp | 0;
            prev = userInfo.experience.prevLevelExp | 0;

            if ((next - prev) <= 0) {
                return 0;
            }

            result = 100 * ((current - prev) / (next - prev));
            result = result < 0 ? 0 : result;
            result = result > 100 ? 100 : result;

            return result;
        }

        function setError() {
            d.loading = false;
            d.isError = true;
            d.errorMessage = qsTr("DETAILED_USER_INFO_DEFAULT_ERROR").arg(d.targetNickname || d.targetUserId);
        }

        function presenceStatusToColor(status) {
            switch(status) {
            case "online":
            case "chat":
                return Styles.messengerContactPresenceOnline;
            case "dnd":
            case "away":
            case "xa":
                return Styles.messengerContactPresenceDnd;
            case "offline":
            default:
                return Styles.messengerContactPresenceOffline;
            }
        }
    }

    Connections {
        target: SignalBus
        onOpenDetailedUserInfo: d.open(opt);
        onCloseDetailedUserInfo: d.close();
    }

    Background {
        anchors.fill: parent
    }

    Item {
        anchors {
            fill: parent
            margins: 1
        }

        Header {
            id: header

            name: d.nickname || d.targetNickname || d.targetUserId
            statusColor: d.presenceStatusToColor(d.status)
        }

        NumberAnimation {
            id: showAnimation

            target: contentItem
            property: "opacity"
            duration: 250
            easing.type: Easing.InOutQuad
            from: 0
            to: 1

            onStopped: mainInfoItem.progressBar = mainInfoItem.progress
        }

        Item { // Body
            anchors {
                fill: parent
                topMargin: 35
            }
            clip: true

            Item { // Content
                id: contentItem

                anchors.fill: parent

                Flickable {
                    id: flickable

                    anchors { fill: parent }
                    contentWidth: width
                    boundsBehavior: Flickable.StopAtBounds

                    Column {
                        id: column

                        width: parent.width

                        onHeightChanged: flickable.contentHeight = height;

                        MainInfo {
                            id: mainInfoItem

                            ratingIcon: d.imageRoot + "premiumIcon.png"
                            premiumIcon: d.imageRoot + "ratingIcon.png"
                        }

                        GameInfo {
                            id: gameInfoItem

                            gameCount: 2
                            onFinished: d.parseCharsFinished();
                        }
                    }
                }

                ScrollBar {
                    flickable: flickable
                    anchors {
                        right: parent.right
                        rightMargin: 3
                    }
                    height: parent.height
                    scrollbarWidth: 6
                    allwaysShown: true
                }

            }

            Rectangle { // Loading Progress
                id: loadingProgres

                anchors.fill: parent

                opacity: (d.loading || d.isError) ? 1 : 0
                visible: opacity > 0
                color: Styles.popupBlockBackground

                Wait {
                    id: waitProgres

                    anchors.centerIn: parent
                    running: d.loading && !d.isError
                    visible: running
                }

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 10
                        verticalCenter: parent.verticalCenter
                    }

                    color: Styles.lightText
                    text: d.errorMessage
                    visible: !d.loading && d.isError
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}

