import QtQuick 1.1

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property string filterGameId: serviceList()

    function serviceList() {
        var result = "-1";

        for (var i = 0; i < App.gamesListModel.count; ++i) {
            var item = App.gamesListModel.get(i);
            if (item && App.isServiceInstalled(item.serviceId)) {
                if (result == '-1') {
                    result = 'gameId=' + item.gameId;
                } else {
                    result += ' or gameId=' + item.gameId;
                }
            }
        }

        return result;
    }

    width: baseView.width
    height: baseView.height

    XmlListModel {
        id: feed

        xml: root.model.newsXml
        query: filterGameId === "-1" ? "/response/news/row" : ("/response/news/row[" + root.filterGameId + "]")

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
                baseView.listView.model = feed;
            }
        }
    }

    BaseView {
        id: baseView
    }
}