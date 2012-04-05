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
import Tulip 1.0
import "../Elements" as Elements
import "../js/GoogleAnalytics.js" as GoogleAnalytics
import "../js/restapi.js" as RestApi

Item {
    id: newsBlock

    property string filterGameId: "631"

    signal newsReady();

    function reloadNews() {
        newsBlock.newsReady();
    }

    implicitWidth: 313
    implicitHeight: 141
    state: "AboutGameTab"

    Component.onCompleted: newsItem.reloadNews();

    QtObject {
        id: d

        function getExecuteCount() {
            if (qGNA_main.currentGameItem) {
                var successCount = parseInt(Settings.value('gameExecutor/serviceInfo/' + qGNA_main.currentGameItem.serviceId, 'successCount', 0));
                var failCount = parseInt(Settings.value('gameExecutor/serviceInfo/' + qGNA_main.currentGameItem.serviceId, 'failedCount', 0));
                return successCount + failCount;
            }

            return 0;
        }

        function timeStampToTimeConverter(timeValue) {
            var a = new Date(timeValue * 1000);
            return a.getDate() + "." + (a.getMonth() + 1) + "." + a.getFullYear();
        }
    }

    Connections {
        target: qGNA_main
        onCurrentGameItemChanged: {
            newsBlock.state = qGNA_main.currentGameItem
                    ? (d.getExecuteCount() > 0 ? "NewsTab": "AboutGameTab")
                    : "AboutGameTab";
        }
    }

    Column {
        spacing: 0

        Row {
            spacing: 0

            Item {
                id: aboutGameTab

                property bool isUnderline: false

                width: 70
                height: 25

                Rectangle {
                    anchors.fill: parent
                    color: "#0066cc"
                    opacity: 0.75
                }

                Elements.TextH4 {
                    anchors.centerIn: parent
                    font { bold: true; underline: aboutGameTab.isUnderline }
                    text: qsTr("TAB_NEWS_ABOUT_GAME")
                }

                Elements.CursorMouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        GoogleAnalytics.trackEvent('/newsBlock/' + qGNA_main.currentGameItem.gaName,
                                                   'Navigation', 'About Game');
                        newsBlock.state = "AboutGameTab"
                    }
                }
            }

            Item {
                id: newsTab

                property bool isUnderline: false;

                width: 70
                height: 26

                Rectangle {
                    anchors { fill: parent; leftMargin: 1 }
                    color: "#0066cc"
                    opacity: 0.75
                }

                Elements.TextH4 {
                    anchors.centerIn: parent
                    font { bold: true; underline: newsTab.isUnderline }
                    text: qsTr("TAB_NEWS")
                }

                Elements.CursorMouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        if (qGNA_main && qGNA_main.currentGameItem) {
                            GoogleAnalytics.trackEvent('/newsBlock/' + qGNA_main.currentGameItem.gaName,
                                                       'Navigation', 'News');
                        }

                        newsBlock.state = "NewsTab"
                    }
                }
            }

            Item {
                width: 64
                height: 25
                visible: qGNA_main.currentGameItem != undefined  && qGNA_main.currentGameItem.blogUrl

                Rectangle {
                    width: 63
                    height: 25
                    color: "#0066cc"
                    opacity: 0.75
                    anchors { top: parent.top; left: parent.left; leftMargin: 1 }

                    Elements.CursorMouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            GoogleAnalytics.trackEvent('/newsBlock/' + qGNA_main.currentGameItem.gaName,
                                                       'Navigation', 'Blog');
                            mainAuthModule.openWebPage(qGNA_main.currentGameItem.blogUrl);
                        }
                    }
                }

                Elements.TextH4 {
                    anchors.centerIn: parent
                    font { bold: true; underline: true }
                    text: qsTr("TAB_BLOG")
                }
            }

            Item {
                width: 64
                height: 25

                Rectangle {
                    width: 64
                    height: 25
                    color: "#0066cc"
                    opacity: 0.75
                    anchors { top: parent.top; left: parent.left; leftMargin: 1 }

                    Elements.CursorMouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            GoogleAnalytics.trackEvent('/newsBlock/' + qGNA_main.currentGameItem.gaName,
                                                       'Navigation', 'Forum');
                            mainAuthModule.openWebPage(qGNA_main.currentGameItem.forumUrl);
                        }
                    }
                }

                Elements.TextH4 {
                    anchors.centerIn: parent
                    font { bold: true; underline: true }
                    text: qsTr("TAB_FORUM")
                }
            }
        }

        Rectangle {
            width: 313
            height: 115
            color: "#00000000"

            Rectangle {
                anchors.fill: parent
                color: "#0066cc"
                opacity: 0.75
            }

            Item {
                id: aboutGamesItem
                anchors.fill: parent

                Text {
                    text: qGNA_main.currentGameItem != undefined ? gamesListModel.aboutGameText(qGNA_main.currentGameItem.gameId) : ""
                    textFormat: Text.RichText
                    onLinkActivated: mainAuthModule.openWebPage(link);

                    color: "#ffffff"
                    font.pixelSize: 13
                    anchors { fill: parent; margins: 7 }
                    wrapMode: Text.WordWrap
                }
            }

            Item {
                id: newsItem

                anchors.fill: parent

                property bool timerReload: false

                function reloadNews() {
                    RestApi.Wall.getNewsXml(function(news) {
                        if (news) {
                            feedModel.xml = news;
                        }

                    }, function(){});
                }

                XmlListModel {
                    id: feedModel

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
                        if (feedModel.status == XmlListModel.Ready && feedModel.get(0)) {
                            if (newsItem.timerReload === false) {
                                newsReady();
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

                Rectangle {
                    height: 1
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                    opacity: 0.2
                    color: "#000000"
                }

                Rectangle {
                    height: 1
                    anchors { left: parent.left; right: parent.right }
                    anchors { verticalCenter: parent.verticalCenter; verticalCenterOffset: 1 }
                    opacity: 0.25
                    color: "#ffffff"
                }

                ListView {
                    visible: true;
                    width: parent.width;
                    height: parent.height
                    model: feedModel
                    clip: true
                    interactive: false
                    delegate:  Elements.NewsItem {
                        width: 313
                        height: 57
                        newsTextDate: d.timeStampToTimeConverter(time);
                        newsTextBody: title;
                        newsCommentCount: commentCount
                        newsLikeCount: likeCount
                        newsUrl: "http://www.gamenet.ru/games/" + gameShortName + "/post/" + eventId
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "AboutGameTab"
            PropertyChanges { target: aboutGameTab; height: 26 }
            PropertyChanges { target: newsTab; height: 25 }
            PropertyChanges { target: aboutGameTab; isUnderline: false }
            PropertyChanges { target: newsTab; isUnderline: true }
            PropertyChanges { target: newsItem; visible: false }
            PropertyChanges { target: aboutGamesItem; visible: true }
        },
        State {
            name: "NewsTab"
            PropertyChanges { target: aboutGameTab; height: 25 }
            PropertyChanges { target: newsTab; height: 26 }
            PropertyChanges { target: aboutGameTab; isUnderline: true }
            PropertyChanges { target: newsTab; isUnderline: false }
            PropertyChanges { target: newsItem; visible: true }
            PropertyChanges { target: aboutGamesItem; visible: false }
        }
    ]
}
