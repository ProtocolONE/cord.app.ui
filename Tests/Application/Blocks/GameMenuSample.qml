import QtQuick 2.4
import Tulip 1.0

import GameNet.Components.Widgets 1.0

import Application.Blocks 1.0 as Blocks
import Application.Blocks.GameMenu 1.0 as GameMenu
import Application 1.0


import Application.Core 1.0

Rectangle {
    id: root

    color: Styles.applicationBackground
    width: 1000
    height: 600

    function appendMenuItem(menu, option) {
        var defaultObject = {
            icon: '',
            text: '',
            page: '',
            link: false,
            selectable: false,
            url: '',
        };

        var item = {};
        ['icon', 'text', 'page', 'link', 'selectable', 'url'].forEach(function(e) {
            item[e] = option[e] || defaultObject[e];
        });

        menu.append(item);
    }

    function fillMenu() {

        root.appendMenuItem(menuModel,
                            {
                                icon: "gameMenuNewsIcon",
                                text: "Новости",
                                page: "News",
                                selectable: true
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "gameMenuAboutIcon",
                                text: "Об игре",
                                page: "AboutGame",
                                selectable: true
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "gameMenuForumIcon",
                                text: "Форум",
                                link: true,
                                url: "https://forum.gamenet.ru/forumdisplay.php?f=4"
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "gameMenuGuidesIcon",
                                text: "Гайды",
                                link: true,
                                url: "https://www.gamenet.ru/games/bs/guides/"
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "gameMenuBlogIcon",
                                text: "Блог",
                                link: true,
                                url: "https://www.gamenet.ru/games/bs/blog/"
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "gameMenuSettingsIcon",
                                text: "Настройки",
                                page: "GameSettings",
                            });
    }

    Image {
        source: 'https://images.gamenet.ru/pics/app/service/1432643350524.jpg'
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.SecondAccountAuth');
            manager.registerWidget('Application.Widgets.PremiumShop');
            manager.init();
        }
    }

    GameMenu.GameMenu {
        id: gameMenu

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: menuModel

        onUrlClicked: {
            console.log('Game menu open url ', url)
        }

        onPageClicked: {
            console.log('Game menu open page ', page)
        }
    }

    Bootstrap {
        anchors.fill: parent
        Component.onCompleted: {
            root.fillMenu();
        }
    }

    ListModel {
        id: menuModel
    }
}
