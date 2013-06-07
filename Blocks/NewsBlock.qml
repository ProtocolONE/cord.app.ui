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

    property string filterGameId: "631"

    signal newsReady();

    function reloadNews() {
        newsBlock.newsReady();
    }

    implicitWidth: 450
    implicitHeight: 206
    state: "AboutGameTab"

    Component.onCompleted: {

        DateHelper.setMonthNames([qsTr("JANUARY"), qsTr("FEBRUARY"), qsTr("MARCH"), qsTr("APRIL"), qsTr("MAY"),
                                 qsTr("JUNE"), qsTr("JULY"), qsTr("AUGUST"), qsTr("SEPTEMBER"), qsTr("OCTOBER"),
                                 qsTr("NOVEMBER"), qsTr("DECEMBER")]);

        newsItem.reloadNews();
    }

    QtObject {
        id: d

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
            newsBlock.state = Core.currentGame()
                    ? (d.getExecuteCount() > 0 ? "NewsTab": "AboutGameTab")
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
                    mainAuthModule.openWebPage(Core.currentGame().blogUrl);
                }
            }

            Elements.IconButton {

                text: qsTr("TAB_FORUM")
                source: installPath + "images/menu/forum.png"
                onClicked: {
                    GoogleAnalytics.trackEvent('/newsBlock/' + Core.currentGame().gaName,
                                               'Navigation', 'Forum');
                    mainAuthModule.openWebPage(Core.currentGame().forumUrl);
                }
            }

            Elements.IconButton {
                text: qsTr('SUPPORT_ICON_BUTTON')
                source: installPath + "images/menu/help.png"
                onClicked: SupportHelper.show(parent, Core.currentGame() ? Core.currentGame().gaName : '');
            }

            Elements.IconButton {
                text: qsTr('MENU_ITEM_SETTINGS')
                source: installPath + "images/menu/settings.png"
                onClicked: qGNA_main.openSettings();
            }
        }

        Rectangle {
            width: 470
            height: 180
            color: "#00000000"

            Rectangle {
                id: opacityBlock

                anchors { top: parent.top; topMargin: 5 }
                anchors { left: parent.left; right: parent.right; leftMargin: -15 }
                color: "#000000"
                opacity: 0.4

                Image{
                    id: cornerPoint

                    anchors{ right: parent.right; bottom: parent.top }
                    source: installPath + "images/corner.png"
                }
            }

            Item {
                id: aboutGamesItem

                anchors.fill: parent

                Text {
                    id: aboutGamesText

                    text: Core.currentGame() != undefined ? Core.gamesListModel.aboutGameText(Core.currentGame().gameId) : ""
                    textFormat: Text.RichText
                    onLinkActivated: mainAuthModule.openWebPage(link);
                    color: "#ffffff"
                    font{ pixelSize: 17; letterSpacing: -0.5 }
                    smooth: true
                    anchors { topMargin: 18; top: parent.top }
                    anchors { left: parent.left; right: parent.right; rightMargin: 30 }
                    wrapMode: Text.WordWrap
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
                    model: newsItem.currentGame
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
            PropertyChanges { target: opacityBlock; height: aboutGamesText.height + 38 }
            PropertyChanges { target: cornerPoint; anchors.rightMargin: 442 }
        },
        State {
            name: "NewsTab"
            PropertyChanges { target: aboutGameTab; isActive: false }
            PropertyChanges { target: newsTab; isActive: true }
            PropertyChanges { target: newsItem; visible: true }
            PropertyChanges { target: aboutGamesItem; visible: false }
            PropertyChanges { target: opacityBlock; height: 180 }
            PropertyChanges { target: cornerPoint; anchors.rightMargin: 374 }
        }
    ]
}
