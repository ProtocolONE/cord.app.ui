import QtQuick 1.1
import Tulip 1.0
import Application.Blocks 1.0 as Blocks
import Application.Blocks.GameMenu 1.0 as GameMenu

Rectangle {
    id: root

    color: "black"
    width: 800
    height: 600


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

        menu.append(item);
    }

    function fillMenu() {

        root.appendMenuItem(menuModel,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/News.png",
                                text: "Новости",
                                page: "News",
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/About.png",
                                text: "Об игре",
                                page: "AboutGame",
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/Forum.png",
                                text: "Форум",
                                link: true,
                                url: "https://forum.gamenet.ru/forumdisplay.php?f=4"
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/Guides.png",
                                text: "Гайды",
                                link: true,
                                url: "https://www.gamenet.ru/games/bs/guides/"
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/Blog.png",
                                text: "Блог",
                                link: true,
                                url: "https://www.gamenet.ru/games/bs/blog/"
                            });

        root.appendMenuItem(menuModel,
                            {
                                icon: "Assets/Images/Application/Blocks/GameMenu/Settings.png",
                                text: "Настройки игры",
                                page: "GameSettings",
                            });
    }

    Component.onCompleted: {
        root.fillMenu();
    }

    GameMenu.GameMenu {
        id: gameMenu

        anchors.fill: parent
        model: menuModel

        onUrlClicked: {
            console.log('Game menu open url ', url)
        }

        onPageClicked: {
            console.log('Game menu open page ', page)
        }
    }

    ListModel {
        id: menuModel
    }
}
