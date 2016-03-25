import QtQuick 2.4
import QtQuick.XmlListModel 2.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetView {
    id: root

    property string filterGameId: App.currentGame() ? App.currentGame().gameId : '-1'
    property variant newsData: model.news;

    width: baseView.width
    height: baseView.height

    onFilterGameIdChanged:  {
        baseView.opacity = 0;
        updateNews()
    }

    onNewsDataChanged: updateNews()

    function cleanString(value) {
        return value.replace("<![CDATA[", "").replace("]]>", "");
    }

    function updateNews() {
        var news = Lodash._.chain((newsData ? newsData.news : []) || [])
            .filter(function(e) {
                return filterGameId === -1 ? e : (e.gameId == filterGameId || e.gameId == 0);
            })
            .map(function(e){
                e.time = +e.time;
                e.commentCount = +e.commentCount;
                e.likeCount = +e.likeCount;
                e.title = root.cleanString(e.title);
                e.announcement = root.cleanString(e.announcement);
                return e;
            })
            .sortByAll('time')
            .reverse()
            .value();

        var lastGameNews = Lodash._.findLast(news, function(e){
            return e.gameId == filterGameId;
        });

        if (lastGameNews) {
            news = news.filter(function(e) {
                return e.gameId == filterGameId
                    || ((e.time + 7 * 86400) > lastGameNews.time);
            });
        }

        baseView.listView.model.clear();
        news.forEach(function(e){
            baseView.listView.model.append(e)
        });
    }

    BaseView {
        id: baseView

        isSingleMode: true
        onFinished: opacity = 1;

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
}
