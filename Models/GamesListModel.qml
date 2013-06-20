/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.0

ListModel {
    property variant currentGameItem

    //К сожалению только так
    //http://qt-project.org/wiki/Qt_Quick_Carousel#70b4903abcb62ace84264ad0443ae759
    function logoText(gameId) {
       if (logoText["text"] === undefined) {
           logoText.text = {
               "92": qsTr("LOGO_CA"),
               "71": qsTr("LOGO_BS"),
               "83": qsTr("LOGO_GA"),
               "84": qsTr("LOGO_MW2"),
               "70": qsTr("LOGO_WI"),
               "631": qsTr("LOGO_AIKA"),
               "72": qsTr("LOGO_ROT"),
               "759": qsTr("LOGO_FJ"),
           };
       }

       return logoText.text[gameId];
    }

    function aboutGameText(gameId) {
       if (aboutGameText["text"] === undefined) {
           aboutGameText.text = {
               "92": qsTr("GAME_CA_ABOUT_TEXT"),
               "71": qsTr("GAME_BS_ABOUT_TEXT"),
               "83": qsTr("GAME_GA_ABOUT_TEXT"),
               "84": qsTr("GAME_MW2_ABOUT_TEXT"),
               "70": qsTr("GAME_WI_ABOUT_TEXT"),
               "631": qsTr("GAME_AIKA_ABOUT_TEXT"),
               "72": qsTr("GAME_ROT_ABOUT_TEXT"),
               "759": qsTr("GAME_FJ_ABOUT_TEXT"),
           };
       }

       return aboutGameText.text[gameId];
    }

    function miniToolTip(gameId) {
       if (miniToolTip["text"] === undefined) {
           miniToolTip.text = {
               "92": qsTr("GAME_CA_MINI_TOOLTIP"),
               "71": qsTr("GAME_BS_MINI_TOOLTIP"),
               "83": qsTr("GAME_GA_MINI_TOOLTIP"),
               "84": qsTr("GAME_MW2_MINI_TOOLTIP"),
               "70": qsTr("GAME_WI_MINI_TOOLTIP"),
               "631": qsTr("GAME_AIKA_MINI_TOOLTIP"),
               "72": qsTr("GAME_ROT_MINI_TOOLTIP"),
               "759": qsTr("GAME_FJ_MINI_TOOLTIP"),
           };
       }

       return miniToolTip.text[gameId];
    }

    function shortDescribtion(gameId) {
       if (shortDescribtion["text"] === undefined) {
           shortDescribtion.text = {
               "92": qsTr("GAME_CA_MINI_DESC"),
               "71": qsTr("GAME_BS_MINI_DESC"),
               "83": qsTr("GAME_GA_MINI_DESC"),
               "84": qsTr("GAME_MW2_MINI_DESC"),
               "70": qsTr("GAME_WI_MINI_DESC"),
               "631": qsTr("GAME_AIKA_MINI_DESC"),
               "72": qsTr("GAME_ROT_MINI_DESC"),
               "759": qsTr("GAME_FJ_MINI_DESC"),
           };
       }

       return shortDescribtion.text[gameId];
    }

    ListElement {
        imageSource: "images/games/ca_icon_small.png"
        name: "Combat Arms"
        imageSmall: "images/games/ca_icon_small.png"
        imageFooter: "images/games/Combat-Arms.png"
        imageMini: "images/games/ca_icon_mini.png"
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

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1

        allreadyDownloaded: false
        gaName: "CombatArms" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300005010000000000"
        maintenanceProposal2: "300003010000000000"

        licenseUrl: "http://www.combatarms.ru/license"


        itemState: "Normal"
        animationPause: 100
        hasOverlay: false

    }

    ListElement {
        imageSource: "images/games/bs_icon_small.png"
        name: "BS.ru Demonion"
        imageSmall: "images/games/bs_icon_small.png"
        imageFooter: "images/games/BS.png"
        imageMini: "images/games/bs_icon_mini.png"
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

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "BloodAndSoul" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300002010000000000"
        maintenanceProposal2: "300009010000000000"

        licenseUrl: "http://www.bs.ru/license"

        itemState: "Normal"
        animationPause: 150
        hasOverlay: true
    }

    ListElement {
        imageSource: "images/games/aika_icon_small.png"
        name: "Aika2"
        imageSmall: "images/games/aika_icon_small.png"
        imageFooter: "images/games/AIKA-2.png"
        imageMini: "images/games/aika_icon_mini.png"
        imageBig: ""
        imageLogoSmall: "images/games/aika_logo_small.png"
        imageLogoBig: ""
        imageHorizontalSmall: "images/games/aika_icon_horizontal_small.png"
        size: "noraml"

        imageBack : "images/games/aika_back.png"

        serviceId: "300002010000000000"
        gameId: "631"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=3"
        blogUrl: "http://www.gamenet.ru/games/aika/blog/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "Aika2" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300009010000000000"

        licenseUrl: "http://www.aika2.ru/license"

        itemState: "Normal";
        animationPause: 0
        hasOverlay: false
    }

    ListElement {
        imageSource: "images/games/ga_icon_small.png"
        name: "Golden Age"
        imageSmall: "images/games/ga_icon_small.png"
        imageFooter: "images/games/Golden-Age.png"
        imageMini: "images/games/ga_icon_mini.png"
        imageBig: ""
        imageLogoSmall: "images/games/ga_logo_small.png"
        imageLogoBig: ""
        size: "noraml"

        imageBack : "images/games/ga_back.png"
        serviceId: "300007010000000000"
        gameId: "83"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=208"
        blogUrl: "http://www.gamenet.ru/games/ga/blog/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "GoldenAge" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300009010000000000"

        licenseUrl: "http://www.playga.ru/license"

        itemState: "Normal";
        animationPause: 0
        hasOverlay: false
    }


    ListElement {
        imageSource: "images/games/wi_icon_small.png"
        name: "FireStorm"
        imageSmall: "images/games/wi_icon_small.png"
        imageFooter: "images/games/Fire-Storm.png"
        imageMini: "images/games/wi_icon_mini.png"
        imageBig: ""
        imageHorizontalSmall: "images/games/wi_icon_horizontal_small.png"
        imageLogoSmall: "images/games/wi_logo_small.png"
        imageLogoBig: ""
        size: "noraml"

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
        maintenanceProposal1: "300009010000000000"
        maintenanceProposal2: "300002010000000000"

        licenseUrl: "http://www.firestorm.ru/license"

        itemState: "Normal"
        animationPause: 100
        hasOverlay: false
    }

    ListElement {
        imageSource: "images/games/mw_icon_small.png"
        name: "Magic World 2"
        imageSmall: "images/games/mw_icon_small.png"
        imageFooter: "images/games/MW2.png"
        imageMini: "images/games/mw_icon_mini.png"
        imageBig: ""
        imageLogoSmall: "images/games/mw_logo_small.png"
        imageLogoBig: ""
        size: "noraml"

        imageBack : "images/games/mw_back.png"

        serviceId: "300006010000000000"
        gameId: "84"

        forumUrl: "https://forum.gamenet.ru/forumdisplay.php?f=195"
        blogUrl: "http://www.gamenet.ru/games/mw2/blog/"

        status: "Normal" // Error Started Paused Downloading
        statusText: ""
        progress: -1
        allreadyDownloaded: false
        gaName: "MagicWorld2" // Never change please

        maintenance: false
        maintenanceInterval: 0
        maintenanceProposal1: "300003010000000000"
        maintenanceProposal2: "300002010000000000"

        licenseUrl: "http://www.mw2.ru/license"

        itemState: "Normal"
        animationPause: 150
        hasOverlay: false
    }

    ListElement {
        name: "Farm Jane"
        imageFooter: "images/games/Farm-Jane.png"
        imageSmall: "images/games/fj_icon_small.png"
        imageBack : "images/games/fj_back.png"

        size: "noraml"
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
        maintenanceProposal2: "300009010000000000"

        itemState: "Normal";
        animationPause: 0
        hasOverlay: false
    }
}
