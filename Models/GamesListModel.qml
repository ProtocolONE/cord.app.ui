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

        menu.append(item);
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

    //В версии 4.х есть баг с локализацией элементов ListElemnt. Один из вариантов решения такой проблемы является
    //http://qt-project.org/wiki/Qt_Quick_Carousel#70b4903abcb62ace84264ad0443ae759
    //Однако вариант Игоря Бугаева, который написан ниже - быстрее и удобнее поддерживать. Более того
    //он прозрачен для 5.х и при переходе его просто можно будет удалить.
    Component.onCompleted: {
        var fields = ['logoText', 'aboutGameText', 'miniToolTip', 'shortDescription']
            , elem
            , i;

        for (i = 0; i < root.count; i++) {
            elem = root.get(i);
            fields.forEach(function(e) {
                if (elem[e]) {
                    root.setProperty(i, e, qsTr(elem[e]));

                }
            });

            root.fillMenu(elem);
        }
    }
    ListElement {
        name: "Reborn"
        enabled: true
        gameType: "standalone"

        imageSmall: "Assets/Images/games/reborn_icon_small.png"
        imageLogoSmall: "Assets/Images/games/reborn_logo_small.png"
        imageHorizontal: "Assets/Images/games/reborn_icon_horizontal.png"
        imageHorizontalSmall: "Assets/Images/games/reborn_icon_horizontal_small.png"
        imagePopupArt: "Assets/Images/games/Popup/RebornPopupArt.png"
        imageDefault: "Assets/Images/games/Default/reborn.png"

        formFactor: 1
        priority: 0

        serviceId: "300012010000000000"
        gameId: "760"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=405"
        blogUrl: ""
        guideUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "Reborn" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300009010000000000"
        maintenanceProposal2: "300003010000000000"
        maintenanceEndPause: false

        licenseUrl:  "http://www.reborngame.ru/license"

        itemState: "Normal";
        animationPause: 0

        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_REBORN")
        aboutGameText: QT_TR_NOOP("GAME_REBORN_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_REBORN_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_REBORN_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: true
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "https://www.facebook.com/pages/Reborn/397344480387678"
                icon: "Assets/Images/socialNet/fb.png"
            },
            ListElement {
                link: "https://vk.com/reborngame"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        //  INFO: При обращении к элементам GameListModel использовать поле widgets вместо widgetsList
        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "Combat Arms"
        enabled: true
        gameType: "standalone"

        imageSmall: "Assets/Images/games/ca_icon_small.png"
        imageLogoSmall: "Assets/Images/games/ca_logo_small.png"
        imageHorizontal: "Assets/Images/games/ca_icon_horisontal.png"
        imageHorizontalSmall: "Assets/Images/games/ca_icon_horizontal_small.png"
        imagePopupArt: "Assets/Images/games/Popup/CombatArmsPopupArt.png"
        imageDefault: "Assets/Images/games/Default/ca.png"

        formFactor: 2
        priority: 1

        serviceId: "300009010000000000"
        gameId: "92"

        ratingUrl: "http://www.combatarms.ru/ratings/user/"
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=262"
        blogUrl: "http://www.gamenet.ru/games/ca/blog/"
        guideUrl: "http://www.gamenet.ru/games/ca/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1

        allreadyDownloaded: false
        gaName: "CombatArms" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300012010000000000"
        maintenanceProposal2: "300003010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://www.combatarms.ru/license"

        itemState: "Normal"
        animationPause: 100
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_CA")
        aboutGameText: QT_TR_NOOP("GAME_CA_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_CA_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_CA_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: false
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "http://www.youtube.com/user/CombatArmsRussia"
                icon: "Assets/Images/socialNet/yt.png"
            },
            ListElement {
                link: "https://www.facebook.com/pages/Combat-Arms-RU/465773090177989"
                icon: "Assets/Images/socialNet/fb.png"
            },
            ListElement {
                link: "http://www.odnoklassniki.ru/group/52003182084281"
                icon: "Assets/Images/socialNet/ok.png"
            },
            ListElement {
                link: "http://vk.com/ca_ru"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "BS.ru Demonion"
        enabled: true
        gameType: "standalone"

        imageSmall: "Assets/Images/games/bs_icon_small.png"
        imageHorizontal: "Assets/Images/games/bs_icon_horizontal.png"
        imageHorizontalSmall: "Assets/Images/games/bs_icon_horizontal_small.png"
        imageLogoSmall: "Assets/Images/games/bs_logo_small.png"
        imagePopupArt: "Assets/Images/games/Popup/BSPopupArt.png"
        imageDefault: "Assets/Images/games/Default/bs.png"

        size: "doubleHorizontal"
        formFactor: 2
        priority: 2

        serviceId: "300003010000000000"
        gameId: "71"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=4"
        blogUrl: "http://www.gamenet.ru/games/bs/blog/"
        guideUrl: "http://www.gamenet.ru/games/bs/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "BloodAndSoul" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300002010000000000"
        maintenanceProposal2: "300012010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://www.bs.ru/license"

        itemState: "Normal"
        animationPause: 150
        hasOverlay: true

        logoText: QT_TR_NOOP("LOGO_BS")
        aboutGameText: QT_TR_NOOP("GAME_BS_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_BS_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_BS_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: true

        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "http://www.youtube.com/bloodandsoulru"
                icon: "Assets/Images/socialNet/yt.png"
            },
            ListElement {
                link: "http://www.facebook.com/pages/Blood-Soul/201464389893835"
                icon: "Assets/Images/socialNet/fb.png"
            },
            ListElement {
                link: "http://vk.com/bloodandsoul"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "Ферма Джейн"
        enabled: true
        gameType: "browser"

        imageSmall: "Assets/Images/games/fj_icon_small.png"
        imageHorizontalSmall: "Assets/Images/games/fj_horizontal_small.png"
        imageDefault: "Assets/Images/games/Default/farm.png"

        formFactor: 1
        priority: 3

        serviceId: "300011010000000000"
        gameId: "759"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=405"
        blogUrl: ""
        guideUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "Reborn" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300009010000000000"
        maintenanceProposal2: "300003010000000000"
        maintenanceEndPause: false

        licenseUrl:  "http://www.reborngame.ru/license"

        itemState: "Normal";
        animationPause: 0

        hasOverlay: true

        logoText: QT_TR_NOOP("LOGO_REBORN")
        aboutGameText: QT_TR_NOOP("GAME_REBORN_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_REBORN_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_REBORN_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: true
        menu: []
        currentMenuIndex: 1

        socialNet: [
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "Aika2"
        enabled: true
        gameType: "standalone"

        imageSmall: "Assets/Images/games/aika_icon_small.png"
        imageLogoSmall: "Assets/Images/games/aika_logo_small.png"
        imageHorizontalSmall: "Assets/Images/games/aika_icon_horizontal_small.png"
        imagePopupArt: "Assets/Images/games/Popup/AikaPopupArt.png"
        imageDefault: "Assets/Images/games/Default/aika2.png"

        formFactor: 2
        priority: 5

        serviceId: "300002010000000000"
        gameId: "631"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=3"
        blogUrl: "http://www.gamenet.ru/games/aika/blog/"
        guideUrl: "http://www.gamenet.ru/games/aika/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "Aika2" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300012010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://www.aika2.ru/license"

        itemState: "Normal";
        animationPause: 0

        // 26.08.2031 HACK Выключено из-за проблемы на XP
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_AIKA")
        aboutGameText: QT_TR_NOOP("GAME_AIKA_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_AIKA_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_AIKA_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: true
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "http://www.youtube.com/user/GamenetAika"
                icon: "Assets/Images/socialNet/yt.png"
            },
            ListElement {
                link: "http://vk.com/aikaonlineru"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "Golden Age"
        enabled: true
        gameType: "browser"

        imageSmall: "Assets/Images/games/ga_icon_small.png"
        imageLogoSmall: "Assets/Images/games/ga_logo_small.png"

        imageDefault: "Assets/Images/games/ga_icon_small.png"
        formFactor: 1
        priority: 4

        serviceId: "300007010000000000"
        gameId: "83"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=208"
        blogUrl: "http://www.gamenet.ru/games/ga/blog/"
        guideUrl: "http://www.gamenet.ru/games/ga/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "GoldenAge" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300012010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://www.playga.ru/license"

        itemState: "Normal";
        animationPause: 0
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_GA")
        aboutGameText: QT_TR_NOOP("GAME_GA_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_GA_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_GA_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: false
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "https://vk.com/golden_age_game"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "FireStorm"
        enabled: true
        gameType: "standalone"

        imageSmall: "Assets/Images/games/fs_icon_small.png"
        imageHorizontalSmall: "Assets/Images/games/wi_icon_horizontal_small.png"
        imageLogoSmall: "Assets/Images/games/fs_icon_small.png"
        imagePopupArt: "Assets/Images/games/Popup/FireStormPopupArt.png"

        imageDefault: "Assets/Images/games/fs_icon_small.png"
        formFactor: 1
        priority: 6

        serviceId: "300005010000000000"
        gameId: "70"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=6"
        blogUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "FireStorm" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300012010000000000"
        maintenanceProposal2: "300002010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://www.firestorm.ru/license"

        itemState: "Normal"
        animationPause: 100
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_WI")
        aboutGameText: QT_TR_NOOP("GAME_WI_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_WI_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_WI_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: false
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "http://www.youtube.com/channel/UC6AbThTxwl1VhaLBvnkdiJg"
                icon: "Assets/Images/socialNet/yt.png"
            },
            ListElement {
                link: "http://vk.com/warinc"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "Rage of Titans"
        enabled: true
        gameType: "standalone"

        imageSmall: "Assets/Images/games/rot_icon_small.png"
        imageLogoSmall: "Assets/Images/games/rot_logo_small.png"
        imagePopupArt: "Assets/Images/games/Popup/RotPopupArt.png"

        imageDefault: "Assets/Images/games/rot_icon_small.png"
        formFactor: 1
        priority: 7

        serviceId: "300004010000000000"
        gameId: "72"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=5"
        blogUrl: ""
        guideUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "RageOfTitans" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300012010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://www.rot.ru/license"

        itemState: "Normal"
        animationPause: 150
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_ROT")
        aboutGameText: QT_TR_NOOP("GAME_ROT_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_ROT_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_ROT_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: false
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "http://vk.com/rageoftitans"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

    ListElement {
        name: "Black Desert"
        enabled: true
        gameType: "browser"

        imageSmall: "Assets/Images/games/bd_icon_small.png"
        imageLogoSmall: "Assets/Images/games/bd_logo_small.png"

        imageDefault: "Assets/Images/games/bd_icon_small.png"
        formFactor: 1
        priority: 8

        serviceId: "30000000000"
        gameId: "1021"

        ratingUrl: ""
        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=436"
        blogUrl: ""
        guideUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "BlackDesert" // Never change please

        maintenance: false
        ignoreMaintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300009010000000000"
        maintenanceProposal2: "300012010000000000"
        maintenanceEndPause: false

        licenseUrl: "http://blackdesert.ru/"

        itemState: "Normal";
        animationPause: 0
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_BD")
        aboutGameText: QT_TR_NOOP("GAME_BD_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_BD_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_BD_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: false
        menu: []
        currentMenuIndex: 1

        socialNet: [
            ListElement {
                link: "https://www.youtube.com/user/BlackDesertRussia"
                icon: "Assets/Images/socialNet/yt.png"
            },
            ListElement {
                link: "https://www.facebook.com/blackdesertrussia"
                icon: "Assets/Images/socialNet/fb.png"
            },
            ListElement {
                link: "https://vk.com/bdo.russia"
                icon: "Assets/Images/socialNet/vk.png"
            }
        ]

        widgetList: ListElement {
           gameDownloading: 'GameAdBanner'
           gameStarting: 'GameAdBanner'
           gameFailedFinish: 'GameFailed'
           gameBoredFinish: 'GameIsBoring'
           gameSuccessFinish: ''
        }
    }

}
