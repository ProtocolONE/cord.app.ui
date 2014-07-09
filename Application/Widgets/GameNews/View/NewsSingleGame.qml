import QtQuick 1.1

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Core/App.js" as App

WidgetView {
    id: root

    property string filterGameId: App.currentGame() ? App.currentGame().gameId : '-1'

    onFilterGameIdChanged: baseView.opacity = 0;

    width: baseView.width
    height: baseView.height

    XmlListModel {
        id: feed

        xml: root.model.newsXml
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
                baseView.listView.model = feed;
            }
        }
    }

    BaseView {
        id: baseView

        isSingleMode: true

        onFinished: opacity = 1;

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
}
