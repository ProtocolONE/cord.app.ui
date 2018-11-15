import QtQuick 2.4
import QtQuick.XmlListModel 2.0

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0

WidgetView {
    id: root

    property string filterGameId: App.currentGame() ? App.currentGame().serviceId : '-1'
    property variant newsData: model.news;

    width: baseView.width
    height: baseView.height

    onFilterGameIdChanged:  {
        baseView.opacity = 0;
        updateNews()
    }

    onNewsDataChanged: updateNews()

    function updateNews() {
        var news = Lodash._.chain((newsData ? newsData : []) || [])
            .filter(function(e) {
                return filterGameId === -1 ? e : (e.game.id == filterGameId);
            })
            .map(function(e) {

                return {
                    time: +(new Date(e.createDate)),
                    title: e.title,
                    announcement: e.announcement,
                    previewImage: e.appImage || '',
                    gameId: e.game.id,
                    gameName: e.game.name
                }
            })
            .sortByAll(['isSticky', 'time'])
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
