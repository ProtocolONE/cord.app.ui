import QtQuick 1.1
import GameNet.Controls 1.0
import GameNet.Components.JobWorker 1.0

import "../../../../../GameNet/Core/lodash.js" as Lodash
import "../../../../../GameNet/Core/RestApi.js" as RestApi
import "../../../../Core/App.js" as App

import "../User.js" as UserJs
import "./PlayingGame.js" as Js

Item {
    id: root

    property variant messenger
    property alias model: proxyModel

    QtObject {
        id: d

        property bool shouldResendGamingInfo: false

        function rosterReceived() {
            var usersMap = {}
                , users = []
                , i
                , usersToInsert
                , usersToRemove;

            if (d.shouldResendGamingInfo) {
                d.shouldResendGamingInfo = false;
                d.resendGamingInfo();
            }

            d.build(usersMap, users);

            if (users.length === 0) {
                d.clearModel();
                return;
            }

            if (Js.sortedUsers.length == 0) {
                d.fillEmptyModel(usersMap, users);
                return;
            }

            usersToInsert = Lodash._.difference(users, Js.sortedUsers);
            usersToRemove = Lodash._.difference(Js.sortedUsers, users);

            d.removeUsers(usersToRemove);
            d.insertUsers(usersToInsert, usersMap);
        }

        function build(usersMap, users) {
            var usersModel = root.messenger.getUsersModel()
                , i
                , jid
                , modelUser
                , playingGame
                , gameItem
                , gameName;

            for (i = 0; i < usersModel.count; ++i) {
                modelUser = usersModel.get(i);
                if (!UserJs.isOnline(modelUser.presenceState) || UserJs.isGameNet(modelUser) || !modelUser.inContacts) {
                    continue;
                }

                playingGame = modelUser.playingGame || "";
                if (!playingGame || !App.serviceExists(playingGame)) {
                    continue;
                }

                gameItem = App.serviceItemByServiceId(playingGame);
                jid = modelUser.jid;

                usersMap[jid] = {
                    nickname: modelUser.nickname.toLowerCase(),
                    gameName: gameItem.name.toLowerCase()
                };

                users.push(jid);
            }
        }

        function fillEmptyModel(usersMap, users) {
            users.sort(function(a, b) {
                var gameName1 = usersMap[a].gameName;
                var gameName2 = usersMap[b].gameName;

                if (gameName1 < gameName2) {
                    return -1;
                }

                if (gameName1 > gameName2) {
                    return 1;
                }

                var nickname1 = usersMap[a].nickname;
                var nickname2 = usersMap[b].nickname;

                if (nickname1 === nickname2) {
                    return 0;
                }

                if (nickname1 < nickname2) {
                    return -1;
                }

                return 1;
            });

            users.forEach(function(u) {
                proxyModel.append({ jid: u });
            })

            Js.sortedUsers = users;
        }

        function insertUsers(users, usersMap) {
            users.forEach(function(newUser) {
                var index = d.findInsertIndex(usersMap, newUser);
                Js.sortedUsers.splice(index, 0, newUser);
                proxyModel.insert(index, {
                                      jid: newUser
                                  });
            });
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
            proxyModel.remove(deleteIndex);
        }

        function findUser(jid) {
            return Lodash._.findIndex(Js.sortedUsers, function(u) {
                return u === jid;
            })
        }

        function findInsertIndex(usersMap, jid) {
            var index
                , nickname = usersMap[jid].nickname
                , gameName = usersMap[jid].gameName;

            index = Lodash._.findIndex(Js.sortedUsers, function(u) {
                var gameName1 = usersMap[u].gameName;
                if (gameName > gameName1) {
                    return false;
                }

                if (gameName < gameName1) {
                    return true;
                }

                var nickname1 = usersMap[u].nickname;

                if (nickname > nickname1) {
                    return false;
                }

                return true;
            });

            return index >= 0 ? index : Js.sortedUsers.length;
        }

        function findInsertIndexNoMap(jid) {
            var user = root.messenger.getUser(jid)
                , gameItem
                , gameName
                , nickname
                , index;

            gameItem = App.serviceItemByServiceId(user.playingGame);
            gameName = gameItem.name.toLowerCase();
            nickname = user.nickname.toLowerCase();

            index = Lodash._.findIndex(Js.sortedUsers, function(u) {
                var user1 = root.messenger.getUser(u),
                    nickname1 = user1.nickname.toLowerCase(),
                    playingGame1 = user1.playingGame,
                    gameItem1 = App.serviceItemByServiceId(playingGame1),
                    gameName1 = gameItem1 ? gameItem1.name.toLowerCase() : ''

                if (gameName > gameName1) {
                    return false;
                }

                if (gameName < gameName1) {
                    return true;
                }

                if (nickname > nickname1) {
                    return false;
                }

                return true;
            });

            return index >= 0 ? index : Js.sortedUsers.length;
        }

        function onlineChanged(jid) {
            var user = root.messenger.getUser(jid)
                , index
                , playingGame;

            if (user.online) {
                playingGame = user.playingGame;
                if (!playingGame) {
                    return;
                }

                index = d.findInsertIndexNoMap(jid);
                Js.sortedUsers.splice(index, 0, jid);
                proxyModel.insert(index, {
                                      jid: jid
                                  });

            } else {
                index = d.findUser(jid);
                if (index !== -1) {
                    Js.sortedUsers.splice(index, 1);
                    proxyModel.remove(index);
                }
            }
        }

        function processGamingInfo(info) {
            var jid
                , user
                , currentPlayingGame
                , gameUri
                , scheme
                , host
                , serviceId = ""
                , index
                , insertIndex;

            jid = UserJs.jidWithoutResource(info.from);

            if (jid === messenger.authedUser().jid) {
                return;
            }

            user = messenger.getUser(jid);
            if (!user.isValid()) {
                return;
            }

            currentPlayingGame = user.playingGame;

            gameUri = new RestApi.Uri(info.uri);
            scheme = gameUri.scheme();
            host = gameUri.host();

            if (scheme === 'gamenet://' && host === 'startservice') {
                serviceId = gameUri.path().split('/')[1] || "";
                if (!App.serviceExists(serviceId)) {
                    serviceId = "";
                }
            }

            if (serviceId === currentPlayingGame) {
                return;
            }

            user.playingGame = serviceId;

            if (!serviceId) {
                d.removeUser(jid);
                return;
            }

            index = d.findUser(jid);
            if (index !== -1) {
                Js.sortedUsers.splice(index, 1);
            }

            insertIndex = d.findInsertIndexNoMap(jid);
            Js.sortedUsers.splice(insertIndex, 0, jid);

            if (index !== insertIndex) {
                if (index !== -1) {
                    proxyModel.move(index, insertIndex, 1);
                } else {
                    proxyModel.insert(insertIndex, {
                                          jid: jid
                                      });
                }
            }
        }

        function setGamingInfo(info) {
            root.messenger.getJabberClient().setGamingInfo(info);
        }

        function resendGamingInfo() {
            var info, serviceId;

            serviceId = App.currentRunningMainService() || App.currentRunningSecondService();
            if (serviceId) {
                info = {
                    uri: 'gamenet://startservice/' + serviceId + '/',
                    name: App.serviceItemByServiceId(serviceId).name
                };
            }

            d.setGamingInfo(info);
        }

        function clearModel() {
            Js.sortedUsers = [];
            proxyModel.clear();
        }
    }

    Connections {
        target: root.messenger

        onRosterReceived: d.rosterReceived();
        onOnlineStatusChanged: d.onlineChanged(jid);
        onConnectedToServer: d.shouldResendGamingInfo = true;
    }

    Connections {
        target: messenger.getJabberClient()

        onGamingInfoReceived: d.processGamingInfo(info)
        onDisconnected: d.clearModel()
    }

    Connections {
        target: App.signalBus();

        onServiceStarted: {
            var info = {
                uri: 'gamenet://startservice/' + gameItem.serviceId + '/',
                name: gameItem.name
            };

            d.setGamingInfo(info);
        }

        onServiceFinished: d.setGamingInfo();
    }

    ListModel {
        id: proxyModel
    }
}
