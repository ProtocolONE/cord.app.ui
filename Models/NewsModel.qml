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
import "../Features/News/News.js" as News

Item {
    id: newsItem

    property string filterGameId: "-1"
    property alias model: feed

    signal newsReady()

    function updateNews() {
        feed.xml = News.getNews();
    }

    Component.onCompleted: News.subscribe(newsItem)

    XmlListModel {
        id: feed

        query: filterGameId === "-1" ? "/response/news/row" : ("/response/news/row[gameId=" + filterGameId + "]")

        XmlRole { name: "gameId"; query: "gameId/string()" }
        XmlRole { name: "gameShortName"; query: "gameShortName/string()" }
        XmlRole { name: "eventId"; query: "eventId/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "announcement"; query: "announcement/string()" }
        XmlRole { name: "time"; query: "time/number()" }
        XmlRole { name: "commentCount"; query: "commentCount/number()" }
        XmlRole { name: "likeCount"; query: "likeCount/number()" }

        onStatusChanged: {
            if (feed.status == XmlListModel.Ready && feed.get(0)) {
                if (!News.timerReload()) {
                    newsReady();
                }
                News.setTimerReload(false);
            }
        }
    }
}
