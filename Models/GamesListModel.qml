/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import Tulip 1.0
import QtQuick 1.1

ListModel {
    id: root

    property variant currentGameItem

    function appendMenuItem(menu, option) {
        var defaultObject = {
            icon: '',
            text: '',
            page: '',
            link: false,
            url: '',
        };

        var item = {};
        ['icon', 'text', 'page', 'link', 'url'].forEach(function(e) {
            item[e] = option[e] || defaultObject[e];
        });

        menu.push(item);
    }

    function fillMenu(element) {
        root.appendMenuItem(element.menu,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/News.png",
                                text: qsTr("GAME_MENU_NEWS_TEXT"),
                                page: "News",
                            });

        root.appendMenuItem(element.menu,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/About.png",
                                text: qsTr("GAME_MENU_ABOUT_GAME_TEXT"),
                                page: "AboutGame",
                            });

        if (element.blogUrl) {
            root.appendMenuItem(element.menu,
                                {
                                    link: true,
                                    icon: "Assets/Images/Application/Blocks/GameMenu/Blog.png",
                                    text: qsTr("GAME_MENU_BLOG_TEXT"),
                                    url: element.blogUrl
                                });
        }


        if (element.guideUrl) {
            root.appendMenuItem(element.menu,
                                {
                                    link: true,
                                    icon: "Assets/Images/Application/Blocks/GameMenu/Guides.png",
                                    text: qsTr("GAME_MENU_GUIDES_TEXT"),
                                    url: element.guideUrl
                                });
        }

        if (element.forumUrl) {
            root.appendMenuItem(element.menu,
                                {
                                    link: true,
                                    icon: "Assets/Images/Application/Blocks/GameMenu/Forum.png",
                                    text: qsTr("GAME_MENU_FORUM_TEXT"),
                                    url: element.forumUrl
                                });
        }

        if (element.gameType === "standalone") {
            root.appendMenuItem(element.menu,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/Settings.png",
                                text: qsTr("GAME_MENU_GAME_SETTINGS_TEXT"),
                                page: "GameSettings",
                            });
        }
    }
}
