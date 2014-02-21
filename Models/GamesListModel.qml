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
        }
    }

    ListElement {
        gameType: "standalone"
        imageSource: "images/games/ca_icon_small.png"
        name: "Combat Arms"
        imageSmall: "images/games/ca_icon_small.png"
        imageFooter: "images/games/Combat-Arms.png"
        imageBig: "images/games/ca_icon_big.png"
        imageHorizontalSmall: "images/games/ca_icon_horizontal_small.png"
        imageHorizontal: "images/games/ca_icon_horisontal.png"
        imageLogoSmall: "images/games/ca_logo_small.png"
        imageLogoBig: "images/games/ca_logo_big.png"
        size: "doubleHorizontal"
        imageBack : "images/games/ca_back.png"
        serviceId: "300009010000000000"
        gameId: "92"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=262"
        blogUrl: "http://www.gamenet.ru/games/ca/blog/"
        guideUrl: "http://www.gamenet.ru/games/ca/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1

        allreadyDownloaded: false
        gaName: "CombatArms" // Never change please

        maintenance: false
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
    }

    ListElement {
        gameType: "standalone"
        imageSource: "images/games/bs_icon_small.png"
        name: "BS.ru Demonion"
        imageSmall: "images/games/bs_icon_small.png"
        imageFooter: "images/games/BS.png"
        imageBig: "images/games/bs_icon_big.png"
        imageHorizontal: "images/games/bs_icon_horizontal.png"
        imageHorizontalSmall: "images/games/bs_icon_horizontal_small.png"
        imageLogoSmall: "images/games/bs_logo_small.png"
        imageLogoBig: ""
        size: "doubleHorizontal"
        imageBack : "images/games/bs_back.png"
        serviceId: "300003010000000000"
        gameId: "71"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=4"
        blogUrl: "http://www.gamenet.ru/games/bs/blog/"
        guideUrl: "http://www.gamenet.ru/games/bs/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "BloodAndSoul" // Never change please

        maintenance: false
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
    }

    ListElement {
        gameType: "standalone"
        imageSource: "images/games/reborn_icon_small.png"
        name: "Reborn"
        imageSmall: "images/games/reborn_icon_small.png"
        imageFooter: "images/games/reborn_logo.png"
        imageBig: ""
        imageLogoSmall: "images/games/reborn_logo_small.png"
        imageLogoBig: ""
        imageHorizontal: "images/games/reborn_icon_horizontal.png"
        imageHorizontalSmall: "images/games/reborn_icon_horizontal_small.png"
        size: "doubleHorizontal"

        imageBack : "images/games/reborn_back.png"

        serviceId: "300012010000000000"
        gameId: "760"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=405"
        blogUrl: ""
        guideUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "Reborn" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300009010000000000"
        maintenanceProposal2: "300003010000000000"
        maintenanceEndPause: false

        licenseUrl:  "http://www.reborngame.ru/"

        itemState: "Normal";
        animationPause: 0

        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_REBORN")
        aboutGameText: QT_TR_NOOP("GAME_REBORN_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_REBORN_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_REBORN_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: true
    }

    ListElement {
        gameType: "standalone"
        imageSource: "images/games/aika_icon_small.png"
        name: "Aika2"
        imageSmall: "images/games/aika_icon_small.png"
        imageFooter: "images/games/AIKA-2.png"
        imageBig: ""
        imageLogoSmall: "images/games/aika_logo_small.png"
        imageLogoBig: ""
        imageHorizontalSmall: "images/games/aika_icon_horizontal_small.png"
        size: "normal"

        imageBack : "images/games/aika_back.png"

        serviceId: "300002010000000000"
        gameId: "631"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=3"
        blogUrl: "http://www.gamenet.ru/games/aika/blog/"
        guideUrl: "http://www.gamenet.ru/games/aika/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "Aika2" // Never change please

        maintenance: false
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
    }

    ListElement {
        gameType: "browser"
        name: "Ферма Джейн"
        imageFooter: "images/games/Farm-Jane.png"
        imageSmall: "images/games/fj_icon_small.png"
        imageBack : "images/games/fj_back.png"
        imageHorizontalSmall: "images/games/fj_horizontal_small.png"

        size: "normal"
        serviceId: "300011010000000000"
        gameId: "759"

        forumUrl: ""
        blogUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "FermaJane" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300012010000000000"
        maintenanceEndPause: false

        itemState: "Normal";
        animationPause: 0
        hasOverlay: false

        logoText: QT_TR_NOOP("LOGO_FJ")
        aboutGameText: QT_TR_NOOP("GAME_FJ_ABOUT_TEXT")
        miniToolTip: QT_TR_NOOP("GAME_FJ_MINI_TOOLTIP")
        shortDescription: QT_TR_NOOP("GAME_FJ_MINI_DESC")

        secondStatus: "Normal"
        secondAllowed: false
    }

    ListElement {
        gameType: "browser"
        imageSource: "images/games/ga_icon_small.png"
        name: "Golden Age"
        imageSmall: "images/games/ga_icon_small.png"
        imageFooter: "images/games/Golden-Age.png"
        imageBig: ""
        imageLogoSmall: "images/games/ga_logo_small.png"
        imageLogoBig: ""
        size: "normal"

        imageBack : "images/games/ga_back.png"
        serviceId: "300007010000000000"
        gameId: "83"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=208"
        blogUrl: "http://www.gamenet.ru/games/ga/blog/"
        guideUrl: "http://www.gamenet.ru/games/ga/guides/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "GoldenAge" // Never change please

        maintenance: false
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
    }

    ListElement {
        gameType: "standalone"
        imageSource: "images/games/wi_icon_small.png"
        name: "FireStorm"
        imageSmall: "images/games/wi_icon_small.png"
        imageFooter: "images/games/Fire-Storm.png"
        imageBig: ""
        imageHorizontalSmall: "images/games/wi_icon_horizontal_small.png"
        imageLogoSmall: "images/games/wi_logo_small.png"
        imageLogoBig: ""
        size: "normal"

        imageBack : "images/games/wi_back.png"

        serviceId: "300005010000000000"
        gameId: "70"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=6"
        blogUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "FireStorm" // Never change please

        maintenance: false
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
    }

    ListElement {
        gameType: "standalone"
        imageSource: ""
        name: "Rage of Titans"
        imageSmall: ""
        imageFooter: "images/games/rot.png"
        imageBig: ""
        imageLogoSmall: "images/games/rot_logo_small.png"
        imageLogoBig: ""
        size: "normal"

        imageBack : "images/games/rot_back.png"

        serviceId: "300004010000000000"
        gameId: "72"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=5"
        blogUrl: ""
        guideUrl: ""

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "RageOfTitans" // Never change please

        maintenance: false
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
    }
}
