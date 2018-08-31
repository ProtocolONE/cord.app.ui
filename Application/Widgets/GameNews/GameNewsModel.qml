import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Core 1.0

WidgetModel {
    id: rootModel

    property variant news

    function reloadNews() {
        RestApi.Wall.getNews( function(news) {
            rootModel.news = news;
        }, function(){});
    }

    function updateNewsByPush(elem) {

        if (typeof news === "undefined") {
            return;
        }

        // Need to update full
        // Single property doesnt trigger change notification

        var sNumTime = elem.time;
        var pushElem = {};
        pushElem[sNumTime] = elem;
        var newNews = news;

        var newsArray = news["news"];
        Lodash._.assign(newsArray, pushElem);
        newNews["news"] = newsArray;
        news = newNews;
    }

    Component.onCompleted: refreshNewsTimer.start()

    Timer {
        id: refreshNewsTimer

        //INFO from 15 to 60 minutes
        interval: 900000 + Math.floor(Math.random() * 2700000)
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            console.log('Reloading news block');
            rootModel.reloadNews();
        }
    }
}
