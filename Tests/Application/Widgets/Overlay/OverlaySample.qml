///****************************************************************************
//** This file is a part of Syncopate Limited GameNet Application or it parts.
//**
//** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
//** All rights reserved.
//**
//** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
//** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0

import "../../../../Application/Core/App.js" as App

Rectangle {
    id: root

    width: 800
    height: 800
    color: '#EEEEEE'

    function getGameData() {
        return [{
            "gameId":71,
            "serviceId":"300003010000000000",
            "name":"BS.ru",
            "gaName":"BloodAndSoul",
            "gameType":"standalone",
            "genre":"MMORPG",
            "genreId":3,
            "genrePosition":1,
            "imageSmall":"https://images.gamenet.ru/pics/app/service/1421682897544.png",
            "imageHorizontalSmall":"https://images.gamenet.ru/pics/app/service/1418739837872.png",
            "imageLogoSmall":"https://images.gamenet.ru/pics/app/service/1418739840565.png",
            "imagePopupArt":"https://images.gamenet.ru/pics/app/service/1418739843767.png",
            "forumUrl":"https://forum.gamenet.ru/forumdisplay.php?f=4",
            "guideUrl":"/games/bs/guides/",
            "blogUrl":"/games/bs/blog/",
            "licenseUrl":"/games/bs/rules/",

            "maintenanceProposal1":"300002010000000000",
            "maintenanceProposal2":"300012010000000000",

            "logoText":"Романтическая игра",
            "aboutGame":"Мочи козлов в BS!!!",

            "miniToolTip":"Это тупо БС",
            "shortDescription":"БС епта",

            "secondAllowed":true,

            "isPublishedInApp":true,
            "isRunnable":true,
            "iconInApp":"https://images.gamenet.ru/pics/app/service/1421926626182.ico",
            "typeShortcut":"",

            "sortPositionInApp":4,
            "hasOverlay":true,

            "socialNet":[{"id":"vk","name":"VK","link":"http://vk.com/bloodandsoul"},{"id":"fb","name":"Facebook","link":""},{"id":"ok","name":"?????????????","link":""},{"id":"mm","name":"??????","link":""},{"id":"gp","name":"Google+","link":""},{"id":"tw","name":"Twitter","link":""},{"id":"yt","name":"YouTube","link":"http://www.youtube.com/bloodandsoulru"}],
            "backgroundInApp":"https://images.gamenet.ru/pics/app/service/1432643400180.jpg"
        }];
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            Shell.execute(installPath + "Tests/Application/Widgets/Overlay/Tools/NormalWayIntegration.exe", ["-width", "1920", "-height", "1080"]);

            var gamesData = root.getGameData();
            App.fillGamesModel(gamesData);

            manager.registerWidget('Application.Widgets.UserProfile');
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.DetailedUserInfo');
            manager.registerWidget('Application.Widgets.AlertAdapter');

            manager.registerWidget('Application.Widgets.Money');
            manager.registerWidget('Application.Widgets.Overlay');
            manager.init();

            App.setSettingsValue('gameExecutor/serviceInfo/' + serviceId + "/",
                                 "overlayEnabled", 1);

            App.isPublicVersion = function() {
                return true;
            }

            var serviceId = App.serviceItemByGameId("71").serviceId;

            initOverlayTimer.start();
        }
    }

    Timer {
        id: initOverlayTimer

        interval: 3000
        repeat: false
        onTriggered: {
            App.serviceStarted(App.serviceItemByGameId("71"));
            //App.navigate("gogamenetmoney");
        }
    }
}
