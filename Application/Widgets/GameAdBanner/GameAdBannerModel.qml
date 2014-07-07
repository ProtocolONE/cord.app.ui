/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0

import "./GameAdBannerModel.js" as GameAdBannerModel
import "../../Core/restapi.js" as RestApiJs

WidgetModel {
    id: root

    signal adsChanged();

    function refreshAds(gameId) {
        if (GameAdBannerModel.allAds.hasOwnProperty(gameId)) {
            root.adsChanged();
            return;
        }

        RestApiJs.Games.getAdvertising(gameId, function(response) {
            if (!response.hasOwnProperty('banners')) {
                return;
            }
            GameAdBannerModel.allAds[gameId] = response.banners;
            root.adsChanged();
        });
    }

    function getAds(gameId) {
        if (GameAdBannerModel.allAds.hasOwnProperty(gameId)) {
            return GameAdBannerModel.allAds[gameId];
        }
    }

    Timer {
        interval: 21600000 //each 6 hours
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            for (var gameId in GameAdBannerModel.allAds) {
                if (GameAdBannerModel.allAds.hasOwnProperty(gameId)) {
                   root.refreshAds(gameId);
                }
            }
        }
    }
}
