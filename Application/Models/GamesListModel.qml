pragma Singleton
import Tulip 1.0
import QtQuick 2.4

ListModel {
    id: root

    property variant currentGameItem

    function appendMenuItem(menu, option) {
        var defaultObject = {
            icon: '',
            text: '',
            page: '',
            link: false,
            linkIcon: '',
            selectable: false,
            url: '',
        };

        var item = {};
        ['icon', 'text', 'page', 'link', 'selectable', 'url', 'linkIcon'].forEach(function(e) {
            item[e] = option[e] || defaultObject[e];
        });

        menu.push(item);
    }

    function fillMenu(element) {
        root.appendMenuItem(element.menu,
                            {
                                icon: 'gameMenuNewsIcon',
                                text: qsTr("GAME_MENU_NEWS_TEXT"),
                                page: "News",
                                selectable: true,
                            });

        root.appendMenuItem(element.menu,
                            {
                                icon: 'gameMenuAboutIcon',
                                text: qsTr("GAME_MENU_ABOUT_GAME_TEXT"),
                                page: "AboutGame",
                                selectable: true,
                            });

        if (element.blogUrl) {
            root.appendMenuItem(element.menu,
                                {
                                    link: true,
                                    icon: 'gameMenuBlogIcon',
                                    text: qsTr("GAME_MENU_BLOG_TEXT"),
                                    url: element.blogUrl
                                });
    }


        if (element.guideUrl) {
            root.appendMenuItem(element.menu,
                                {
                                    link: true,
                                    icon: 'gameMenuGuidesIcon',
                                    linkIcon: 'linkIconGames',
                                    text: qsTr("GAME_MENU_GUIDES_TEXT"),
                                    url: element.guideUrl
                                });
        }

        if (element.forumUrl) {
            root.appendMenuItem(element.menu,
                                {
                                    link: true,
                                    icon: 'gameMenuForumIcon',
                                    text: qsTr("GAME_MENU_FORUM_TEXT"),
                                    url: element.forumUrl
                                });
        }

        root.appendMenuItem(element.menu,
                        {
                            icon: 'gameMenuSettingsIcon',
                            text: qsTr("GAME_MENU_GAME_SETTINGS_TEXT"),
                            page: "GameSettings",
                        });

    }
}
