/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../../Application/Core/App.js" as App
import "../../../../Application/Core/Styles.js" as Styles

Rectangle {
    width: 800
    height: 800
    color: '#cccccc'

    Component.onCompleted:  {
        Styles.init();
        Styles.setCurrentStyle("sand")
    }

    WidgetManager {
        id: manager

        function getGameData() {
            return [{
                "gameId": 1031,
                "serviceId": "70000000000",
                "name": "Морской Бой",
                "gaName": "SeaFight",
                "gameType":"browser",
                "genre":"Браузерные игры",
                "genreId":1,
                "genrePosition":3,
                "imageSmall":"https://images.gamenet.ru/pics/app/service/1423493068479.png",
                "imageHorizontalSmall":"https://images.gamenet.ru/pics/app/service/1423493127302.png",
                "imageLogoSmall":"https://images.gamenet.ru/pics/app/service/1423493136966.png",
                "imagePopupArt":"https://images.gamenet.ru/pics/app/service/1423493145152.png",
                "forumUrl":"https://forum.gamenet.ru/forumdisplay.php?f=489",
                "guideUrl":"/games/seafight/guides/",
                "blogUrl":"/games/seafight/blog/",
                "licenseUrl":"/games/seafight/rules/",
                "maintenanceProposal1":"300003010000000000",
                "maintenanceProposal2":"90000000000",
                "logoText":"logoText logoText",
                "aboutGame":"О игре. О игре. О игре. О игре. О игре. О игре. О игре. О игре. О игре. О игре. О игре.",
                "miniToolTip":"miniToolTip miniToolTip miniToolTip.",
                "shortDescription":"Морские сражения",
                "secondAllowed":false,
                "widgetList":"\"gameDownloading\":\"GameAdBanner\",\"gameStarting\":\"GameAdBanner\",\"gameFailedFinish\":\"GameFailed\",\"gameBoredFinish\":\"GameIsBoring\",\"gameSuccessFinish\":\"\"",
                "isPublishedInApp":true,
                "isRunnable":true,
                "iconInApp":null,
                "typeShortcut":"",
                "sortPositionInApp":7,
                "hasOverlay":false,
                "socialNet":[{"id":"vk","name":"VK","link":"https://vk.com/sea_battle_gamenet"},{"id":"fb","name":"Facebook","link":""},{"id":"ok","name":"?????????????","link":""},{"id":"mm","name":"??????","link":""},{"id":"gp","name":"Google+","link":""},{"id":"tw","name":"Twitter","link":""},{"id":"yt","name":"YouTube","link":""}],
                "backgroundInApp":"https://images.gamenet.ru/pics/app/service/1433518954383.jpg"
            }, {
                "gameId":1033,
                "serviceId":"90000000000",
                "name":"Bleach",
                "gaName":"Bleach",
                "gameType":"browser",
                "genre":"?????????? ????",
                "genreId":1,
                "genrePosition":3,
                "imageSmall":"https://images.gamenet.ru/pics/app/service/1430300330909.png",
                "imageHorizontalSmall":"https://images.gamenet.ru/pics/app/service/1430300373600.png",
                "imageLogoSmall":"https://images.gamenet.ru/pics/app/service/1430300430950.png",
                "imagePopupArt":"https://images.gamenet.ru/pics/app/service/1430300473473.png",
                "forumUrl":"https://forum.gamenet.ru/forumdisplay.php?f=500",
                "guideUrl":"/games/bleach/guides/",
                "blogUrl":"/games/bleach/blog/",
                "licenseUrl":"/games/bleach/rules/",
                "maintenanceProposal1":"300003010000000000",
                "maintenanceProposal2":"300012010000000000",
                "logoText":"Bleach Bleach",
                "aboutGame":"Bleach - Bleach Bleach Bleach RPG",
                "miniToolTip": "Bleach Bleach Bleach",
                "shortDescription":"Abracadabra",
                "secondAllowed":false,
                "widgetList":"\"gameDownloading\":\"GameAdBanner\",\"gameStarting\":\"GameAdBanner\",\"gameFailedFinish\":\"GameFailed\",\"gameBoredFinish\":\"GameIsBoring\",\"gameSuccessFinish\":\"\"",
                "isPublishedInApp":true,
                "isRunnable":true,
                "iconInApp":null,
                "typeShortcut":"new",
                "sortPositionInApp":3,
                "hasOverlay":false,
                "socialNet":[{"id":"vk","name":"VK","link":"https://vk.com/bleach_gamenet"},{"id":"fb","name":"Facebook","link":""},{"id":"ok","name":"?????????????","link":""},{"id":"mm","name":"??????","link":""},{"id":"gp","name":"Google+","link":""},{"id":"tw","name":"Twitter","link":""},{"id":"yt","name":"YouTube","link":""}],
                "backgroundInApp":"https://images.gamenet.ru/pics/app/service/1433518903634.jpg"
            }, {
                "gameId":71,
                "serviceId":"300003010000000000",
                "name":"BS.ru","gaName":"BloodAndSoul",
                "gameType":"standalone",
                "genre":"MMORPG",
                "genreId":3,
                "genrePosition":1,
                "imageSmall":"https://images.gamenet.ru/pics/app/service/1421682897544.png",
                "imageHorizontalSmall":"https://images.gamenet.ru/pics/app/service/1418739837872.png",
                "imageLogoSmall":"https://images.gamenet.ru/pics/app/service/1418739840565.png",
                "imagePopupArt":"https://images.gamenet.ru/pics/app/service/1418739843767.png",
                "forumUrl":"https://forum.gamenet.ru/forumdisplay.php?f=4",
                "guideUrl":"/games/bs/guides/","blogUrl":"/games/bs/blog/",
                "licenseUrl":"/games/bs/rules/",
                "maintenanceProposal1":"300002010000000000",
                "maintenanceProposal2":"300012010000000000",
                "logoText":"????????????? ??????? ????",
                "aboutGame":"BS ? ???????????? ??????? ????, ?????????? ?????????????? ??????? ???????? ?????????, ?????? ? ????????? ?????????? ? ?????? ?????????? ??????, ??????????? ????? ??????, ??????? ?????, ???????? ??????? ? ???????????? ? ???? BS!","miniToolTip":"???? ???????? ??????-????, ?????? ????? ? ??????????? ???????????? ????????.","shortDescription":"????????????? ?????? ????",
                "secondAllowed":true,
                "widgetList":"\"gameDownloading\":\"GameAdBanner\",\"gameStarting\":\"GameAdBanner\",\"gameFailedFinish\":\"GameFailed\",\"gameBoredFinish\":\"GameIsBoring\",\"gameSuccessFinish\":\"\"",
                "isPublishedInApp":true,
                "isRunnable":true,
                "iconInApp":"https://images.gamenet.ru/pics/app/service/1421926626182.ico",
                "typeShortcut":"",
                "sortPositionInApp":4,
                "hasOverlay":true,
                "socialNet":[{"id":"vk","name":"VK","link":"http://vk.com/bloodandsoul"},{"id":"fb","name":"Facebook","link":""},{"id":"ok","name":"?????????????","link":""},{"id":"mm","name":"??????","link":""},{"id":"gp","name":"Google+","link":""},{"id":"tw","name":"Twitter","link":""},{"id":"yt","name":"YouTube","link":"http://www.youtube.com/bloodandsoulru"}],
                "backgroundInApp":"https://images.gamenet.ru/pics/app/service/1433518917211.jpg"
            }];
        }

        Component.onCompleted: {
            App.downloadButtonStart = function(serviceId) {
                console.log(">>>>>>> downloadButtonStart: ", serviceId);
            }

            manager.registerWidget('Application.Widgets.Maintenance');

            var gamesData = manager.getGameData();
            App.fillGamesModel(gamesData);

            manager.init();

            App.activateGameByServiceId("70000000000");
        }
    }

    WidgetContainer {
        x: 50
        y: 50

        width: 590
        height: 100
        widget: 'Maintenance'
        view: 'MaintenanceLightView'
    }
}
