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
import "../js/support.js" as SupportHelper
import "../js/DateHelper.js" as DateHelper
import "../js/Core.js" as Core
import "../Models" as Models

Item {
    id: newsBlock

    property bool forceShowNews: false
    property string filterGameId: "631"

    implicitWidth: 450
    implicitHeight: 206
    state: "AboutGameTab"

    Component.onCompleted: {

        DateHelper.setMonthNames([qsTr("JANUARY"), qsTr("FEBRUARY"), qsTr("MARCH"), qsTr("APRIL"), qsTr("MAY"),
                                 qsTr("JUNE"), qsTr("JULY"), qsTr("AUGUST"), qsTr("SEPTEMBER"), qsTr("OCTOBER"),
                                 qsTr("NOVEMBER"), qsTr("DECEMBER")]);
    }

    QtObject {
        id: d

        property variant lastOpenExternalBrowserTime: 0

        function openExteranlBorwser(url) {
            var now = (+ new Date()),
                dif = now - d.lastOpenExternalBrowserTime;

            if (dif > 0 && dif < 3000) {
                return;
            }

            d.lastOpenExternalBrowserTime = now;
            mainAuthModule.openWebPage(url);
        }

        function getExecuteCount() {
            if (Core.currentGame()) {
                var successCount = parseInt(Settings.value('gameExecutor/serviceInfo/' + Core.currentGame().serviceId, 'successCount', 0));
                var failCount = parseInt(Settings.value('gameExecutor/serviceInfo/' + Core.currentGame().serviceId, 'failedCount', 0));
                return successCount + failCount;
            }

            return 0;
        }
    }

    Connections {
        target: Core.gamesListModel
        onCurrentGameItemChanged: {
            if (!Core.currentGame()) {
               newsBlock.state = "AboutGameTab";
               return;
            }

            newsBlock.state = Core.currentGame()
                    ? (d.getExecuteCount() > 0 || forceShowNews ? "NewsTab": "AboutGameTab")
                    : "AboutGameTab";
        }
    }

    Column {
        spacing: 10

        Row {
            spacing: 26

            Elements.IconButton {
                id: aboutGameTab

                text: qsTr("TAB_NEWS_ABOUT_GAME")
                source: aboutGameTab.isActive ?  installPath + "images/menu/info_active.png" : installPath + "images/menu/info.png"
                onClicked: {
                    GoogleAnalytics.trackEvent('/newsBlock/' + Core.currentGame().gaName,
                                               'Navigation', 'About Game');
                    newsBlock.state = "AboutGameTab"
                }
            }

            Elements.IconButton {
                id: newsTab

                visible: Core.currentGame() != undefined
                text: qsTr("TAB_NEWS")
                source: newsTab.isActive ? installPath + "images/menu/news_active.png" : installPath + "images/menu/news.png"
                onClicked: {
                    newsBlock.state = "NewsTab"

                    if (qGNA_main && Core.currentGame()) {
                        GoogleAnalytics.trackEvent('/newsBlock/' + Core.currentGame().gaName,
                                                   'Navigation', 'News');
                    }
                }
            }

            Elements.IconButton {
                visible: Core.currentGame() != undefined  && Core.currentGame().blogUrl
                text: qsTr("TAB_BLOG")
                source: installPath + "images/menu/blog.png"
                onClicked: {

                    GoogleAnalytics.trackEvent('/newsBlock/' + Core.currentGame().gaName,
                                               'Navigation', 'Blog');
                    d.openExteranlBorwser(Core.currentGame().blogUrl);
                }
            }

            Elements.IconButton {
                visible: Core.currentGame() != undefined  && Core.currentGame().forumUrl
                text: qsTr("TAB_FORUM")
                source: installPath + "images/menu/forum.png"
                onClicked: {
                    GoogleAnalytics.trackEvent('/newsBlock/' + Core.currentGame().gaName,
                                               'Navigation', 'Forum');
                    d.openExteranlBorwser(Core.currentGame().forumUrl);
                }
            }

            Elements.IconButton {
                visible: Core.currentGame() != undefined
                text: qsTr('SUPPORT_ICON_BUTTON')
                source: installPath + "images/menu/help.png"
                onClicked: SupportHelper.show(newsBlock, Core.currentGame() ? Core.currentGame().gaName : '');
            }

            Elements.IconButton {
                text: qsTr('MENU_ITEM_SETTINGS')
                source: installPath + "images/menu/settings.png"
                onClicked: qGNA_main.openSettings(Core.currentGame());
                visible: Core.currentGame() != undefined  && Core.currentGame().gameType != "browser"
            }
        }

        Rectangle {
            width: 470
            height: 180
            color: "#00000000"

            Item {
                id: aboutGamesItem

                anchors.fill: parent

                Column {
                    anchors { top: parent.top; left: parent.left; right: parent.right }
                    anchors { topMargin: 13; rightMargin: 30 }
                    spacing: 9

                    Text {
                        text: Core.currentGame() != undefined ? Core.currentGame().aboutGameText : ""
                        textFormat: Text.RichText
                        onLinkActivated: mainAuthModule.openWebPage(link);
                        color: "#ffffff"
                        font{ pixelSize: 17; letterSpacing: -0.5 }
                        smooth: true
                        wrapMode: Text.WordWrap
                        anchors{ left: parent.left; right: parent.right }
                    }

                    Text {
                        anchors{ left: parent.left; right: parent.right }

                        text: qsTr("MORE_ABOUT_GAME")
                        visible: Core.currentGame() ? !!Core.currentGame().guideUrl : false
                        color: "#ffffff"
                        font { underline: true; family: "Tahoma"; pixelSize: 15; }
                        smooth: true

                        Elements.CursorMouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var currentGame = Core.currentGame();
                                if (!currentGame)
                                    return;

                                mainAuthModule.openWebPage(currentGame.guideUrl);
                            }
                        }
                    }
                }
            }

            Models.NewsModel {
                id: newsItem

                anchors.fill: parent
                filterGameId: newsBlock.filterGameId

                ListView {
                    visible: true;
                    width: parent.width;
                    height: parent.height
                    model: newsItem.model
                    clip: true
                    interactive: false
                    delegate:  Elements.NewsItem {
                        width: newsItem.width
                        height: 50
                        newsTextDate: DateHelper.toLocaleFormat(new Date(time * 1000), '%d %m');
                        newsTextBody: title;
                        newsCommentCount: commentCount
                        newsLikeCount: likeCount
                        newsUrl: "http://www.gamenet.ru/games/" + gameShortName + "/post/" + eventId
                    }
                }

                Text {
                    anchors{ top: parent.bottom; left: parent.left; right: parent.right }

                    text: qsTr("ALL_NEWS")
                    anchors { rightMargin: 5; topMargin: -14 }
                    color: "#ffffff"
                    font { underline: true; family: "Tahoma"; pixelSize: 15; }
                    smooth: true

                    Elements.CursorMouseArea {
                        anchors { top: parent.top; left: parent.left; bottom: parent.bottom}
                        width: parent.paintedWidth

                        hoverEnabled: true
                        onClicked: {
                            var currentGame = newsItem.model.get(0)
                            if (!currentGame || !currentGame.gameShortName)
                                return;

                            mainAuthModule.openWebPage("http://www.gamenet.ru/games/" + currentGame.gameShortName + "/news/");
                        }
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "AboutGameTab"
            PropertyChanges { target: aboutGameTab; isActive: true }
            PropertyChanges { target: newsTab; isActive: false }
            PropertyChanges { target: newsItem; visible: false }
            PropertyChanges { target: aboutGamesItem; visible: true }
        },
        State {
            name: "NewsTab"
            PropertyChanges { target: aboutGameTab; isActive: false }
            PropertyChanges { target: newsTab; isActive: true }
            PropertyChanges { target: newsItem; visible: true }
            PropertyChanges { target: aboutGamesItem; visible: false }
        }
    ]
}
