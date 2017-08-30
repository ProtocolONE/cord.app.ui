/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Blocks.Popup 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Styles 1.0

import "Private" as Private

WidgetView {
    id: root

    implicitWidth: 770
    implicitHeight: 570

    Component.onCompleted: d.fillGrid();

    onVisibleChanged: {
        if (!d) { // unbelivable....
            return;
        }

        d.rootVisibleChanged()
    }

    QtObject {
        id: d

        function rootVisibleChanged() {
            if (!root || !root.visible) {
                return;
            }

            stateGroup.state = 'Normal';
        }

        function fillGrid() {
            var grid = App.serviceGrid(),
                suggestedUserGames,
                otherSuggestedGames,

                gridServices = {};

            Object.keys(grid).forEach(function(e){
                var item = grid[e];

                if (!App.serviceItemByServiceId(item.serviceId)) {
                    return;
                }
                itemComponent.createObject(baseArea,
                                           {
                                               source: item.image,
                                               serviceItem: App.serviceItemByServiceId(item.serviceId),
                                               serviceItemGrid: item,
                                               serviceId: item.serviceId,
                                               x: (item.col - 1) * 257,
                                               y: (item.row - 1) * 100,
                                               width: (item.width * 255) + (item.width - 1) * 2,
                                               height: (item.height * 98) + (item.height - 1) * 2
                                           });
                gridServices[item.serviceId] = 1;
            });

            //INFO https://jira.gamenet.ru/browse/QGNA-1513
            function buildButtonGameList(response) {
                function parseResponse(response) {
                    if (!response.hasOwnProperty('userInfo') || !response.userInfo[0]) {
                        return [];
                    };

                    //INFO We should take one game with most played time and 2 games sorted by last played time. If
                    //error or empty data we should return games sorted priority from admin.
                    var games = Lodash._.chain(response.userInfo[0].games.lastPlayList)
                        .filter(function(e) {
                            return !!App.serviceItemByGameId(e.gameId);
                        })
                        .map(function(e) {
                            var item = App.serviceItemByGameId(e.gameId);
                            e.serviceId = (item ? item.serviceId : -1);
                            e.isStandalone = item.isStandalone;
                            return e;
                        })
                        .filter(function(e){
                            return e.serviceId !== -1
                                && !gridServices.hasOwnProperty(e.serviceId)
                                && !e.isStandalone
                        })
                        .sortByAll(['totalTime'])
                        .reverse()
                        .value();

                    if (games.length === 0) {
                        return [];
                    }

                    var topGameByTime = games.shift();

                    var resultGames = [topGameByTime.serviceId];
                    var gamesByLastPlayTime = Lodash._.chain(games)
                        .sortByAll(['time'])
                        .reverse()
                        .slice(0, 2)
                        .map('serviceId')
                        .value();

                    return resultGames.concat(gamesByLastPlayTime);
                }

                suggestedUserGames = parseResponse(response);
                otherSuggestedGames = Lodash._.chain(App.getRegisteredServices())
                    .map(App.serviceItemByServiceId)
                    .sortByAll('sortPositionInApp')
                    .filter(function(e){
                        return !gridServices.hasOwnProperty(e.serviceId)
                            && e.serviceId != "0"
                            && !e.isStandalone
                            && suggestedUserGames.indexOf(e.serviceId) === -1;
                    })
                    .slice(0, 7 - suggestedUserGames.length)
                    .map('serviceId')
                    .value();

                gameList.model = suggestedUserGames.concat(otherSuggestedGames);
            }

            RestApi.User.getPlayedInfo([User.userId()], buildButtonGameList, buildButtonGameList);
            gameListPage.update();
        }
    }

    Item {
        id: logoutOverlay
        z: 100
        anchors.fill: parent

        // Detect firsttime show
        function isAppSettingsSet() {
            return AppSettings.value("qGna", "isLogoutHelpShown", 0) == 1;
        }

        //Set property that we this widget was shown
        function setAppsettings() {
            AppSettings.setValue("qGna", "isLogoutHelpShown", 1);
        }

        visible: !logoutOverlay.isAppSettingsSet()

        Rectangle {
            anchors.fill: parent
            opacity: 0.75
            color: "#000000"
        }

        Canvas {
            id: arrowToNameEdit 

            anchors.fill: parent

            property int fromx : 70 
            property int fromy : 110 
            property int tox : 8 
            property int toy : 80

            onPaint: {
                // get context to draw with
                var ctx = getContext("2d")
                ctx.save();
                var headlen = 2;

                var angle = Math.atan2(toy-fromy,tox-fromx);

                //starting path of the arrow from the start square to the end square and drawing the stroke
                ctx.beginPath();
                ctx.moveTo(fromx, fromy);
                ctx.lineTo(tox, toy);
                ctx.strokeStyle = Styles.auxiliaryButtonNormal;
                ctx.lineWidth = 1;
                ctx.stroke();

                //starting a new path from the head of the arrow to one of the sides of the point
                ctx.beginPath();
                ctx.moveTo(tox, toy);
                ctx.lineTo(tox-headlen*Math.cos(angle-Math.PI/7),toy-headlen*Math.sin(angle-Math.PI/7));

                //path from the side point of the arrow, to the other side point
                ctx.lineTo(tox-headlen*Math.cos(angle+Math.PI/7),toy-headlen*Math.sin(angle+Math.PI/7));

                //path from the side point back to the tip of the arrow, and then again to the opposite side point
                ctx.lineTo(tox, toy);
                ctx.lineTo(tox-headlen*Math.cos(angle-Math.PI/7),toy-headlen*Math.sin(angle-Math.PI/7));

                //draws the paths created above
                ctx.strokeStyle = Styles.auxiliaryButtonNormal;
                ctx.lineWidth = 3;
                ctx.stroke();
                ctx.fillStyle = Styles.auxiliaryButtonNormal;
                ctx.fill();
                ctx.restore()
            }
        }

        Text {
            x : 70
            y : 112

            text : qsTr("LOGOUT_HELP_MESSAGE")

            font.pointSize: 10
            color: Styles.auxiliaryButtonNormal
        }

        PrimaryButton {
            x : 70
            y : 150

            width: 100
            height : 40

            text: qsTr("LOGOUT_HELP_OK")

            enabled: !logoutOverlay.isAppSettingsSet()
            onClicked: {
                logoutOverlay.visible = false
            }
        }

        MouseArea {
            visible: parent.opacity > 0
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            onClicked : {
                logoutOverlay.visible = false;
                logoutOverlay.setAppsettings();
            }
        }
    }


    ContentBackground {
    }

    Component {
        id: itemComponent

        Private.GameItem { }
    }

    Column {
        id: gridPage

        anchors {
            fill: parent
            leftMargin: 1
        }
        spacing: 1

        Item {
            id: baseArea

            width: parent.width
            height: 400
            visible: height > 0
            clip: height < 400 ? true : false

            Rectangle {
                anchors.fill: parent
                opacity: 0.75
                color: Styles.contentBackgroundDark
            }

            Behavior on height {
                PropertyAnimation {
                    easing.type: Easing.InQuad
                    duration: 200
                }
            }
        }

        Private.AllButton {
            id: allGamesButon

            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: 8
            }

            onClicked: {
                stateGroup.state = (stateGroup.state === 'Normal') ? 'Opened' : 'Normal'
                Ga.trackEvent('AllGames', 'toggle', 'State ' + stateGroup.state)
            }

            Behavior on iconRotation {
                NumberAnimation { duration: 250 }
            }

        }

        Connections {
            target: SignalBus

            onNavigate: {
                if (link !== 'allgame' || stateGroup.state === 'Normal') {
                    return;
                }

                stateGroup.state = 'Normal';
            }
        }

        Private.GameList {
            id: gameList

            width: parent.width
            visible: opacity > 0

            Behavior on opacity {
                PropertyAnimation {
                    duration: 100
                }
            }

            onClicked: {
                Ga.trackEvent('AllGames Opened', 'click', serviceItem.gaName, 0);
            }
        }

        Private.GameListPage {
            id: gameListPage

            width: parent.width
            height: 570

            visible: opacity > 0

            Behavior on opacity {
                PropertyAnimation {
                    duration: 200
                }
            }

            onClicked: {
                Ga.trackEvent('AllGames Normal', 'click', serviceItem.gaName, 1);
            }
        }
    }

    StateGroup {
        id: stateGroup

        state: "Normal"
        states: [
            State {
                name: "Normal"
                PropertyChanges { target: baseArea; height: 400 }
                PropertyChanges { target: allGamesButon; iconRotation: 0 }
                PropertyChanges { target: gameListPage; visible: false }
                PropertyChanges { target: gameListPage; opacity: 0 }
                PropertyChanges { target: gameList; opacity: 1 }
                PropertyChanges { target: gameListPage; opened: false }
            },
            State {
                name: "Opened"
                PropertyChanges { target: baseArea; height: 0 }
                PropertyChanges { target: allGamesButon; iconRotation: 190 }
                PropertyChanges { target: gameListPage; visible: true }
                PropertyChanges { target: gameListPage; opacity: 1 }
                PropertyChanges { target: gameList; opacity: 0 }
                PropertyChanges { target: gameListPage; opened: true }
            }
        ]
    }
}
