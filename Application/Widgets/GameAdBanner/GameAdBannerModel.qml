import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import "./GameAdBannerModel.js" as GameAdBannerModel

WidgetModel {
    id: root

    signal adsChanged();

    function refreshAds(gameId) {
        if (GameAdBannerModel.allAds.hasOwnProperty(gameId)) {
            root.adsChanged();
            return;
        }


        RestApi.Games.getBanners(gameId, function(code, response) {
            if (!RestApi.ErrorEx.isSuccess(code) || response.length === 0) {
                return;
            }

            GameAdBannerModel.allAds[gameId] = response.filter(function(e) {
                return e.hasOwnProperty('imageApp') && e.imageLauncher !== "";
            }).map(function(e) {
                return {
                    id: e.id,
                    description: e.description || "",
                    image: e.imageApp,
                    link: e.link || ""
                }
            });
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
