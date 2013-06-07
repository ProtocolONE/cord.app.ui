/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

import "../js/restapi.js" as RestApi

Item {
    id: newsItem

    property bool timerReload: false
    property string filterGameId: "631"
    property alias currentGame: feedGame
    property alias allGames: feedAll

    signal newsReady()
    signal allNewsReady()

    function reloadNews() {
        RestApi.Wall.getNewsXml(function(news) {
            if (news) {
                feedGame.xml = news;
                feedAll.xml = news;
            }

        }, function(){});
    }

    XmlListModel {
        id: feedGame

        query: "/response/news/row[gameId=" + filterGameId + "]";

        XmlRole { name: "gameId"; query: "gameId/string()" }
        XmlRole { name: "gameShortName"; query: "gameShortName/string()" }
        XmlRole { name: "eventId"; query: "eventId/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "announcement"; query: "announcement/string()" }
        XmlRole { name: "time"; query: "time/number()" }
        XmlRole { name: "commentCount"; query: "commentCount/number()" }
        XmlRole { name: "likeCount"; query: "likeCount/number()" }

        onStatusChanged: {
            if (feedAll.status == XmlListModel.Ready && feedAll.get(0)) {
                if (newsItem.timerReload === false) {
                    newsReady();
                }

                newsItem.timerReload = false;
            }
        }
    }

    XmlListModel {
        id: feedAll

        query: "/response/news/row";

        XmlRole { name: "gameId"; query: "gameId/string()" }
        XmlRole { name: "gameShortName"; query: "gameShortName/string()" }
        XmlRole { name: "eventId"; query: "eventId/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "announcement"; query: "announcement/string()" }
        XmlRole { name: "time"; query: "time/number()" }
        XmlRole { name: "commentCount"; query: "commentCount/number()" }
        XmlRole { name: "likeCount"; query: "likeCount/number()" }

        onStatusChanged: {
            if (feedAll.status == XmlListModel.Ready && feedAll.get(0)) {
                if (newsItem.timerReload === false) {
                    allNewsReady();
                }

                newsItem.timerReload = false;
            }
        }
    }

    Timer {
        //INFO from 15 to 60 minutes
        interval: 900000 + Math.floor(Math.random() * 2700000)
        running: true
        repeat: true
        onTriggered: {
            console.log('Reloading news block');

            newsItem.timerReload = true;
            newsItem.reloadNews();
        }
    }
}
