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

        RestApi.Games.getAdvertising(gameId, function(response) {
            if (!response.hasOwnProperty('banners')) {
                return;
            }

            if (response.banners.length === 0 && GameAdBannerModel.allAds.hasOwnProperty(gameId)) {
                return;
            }

            GameAdBannerModel.allAds[gameId] = response.banners.filter(function(e) {
                return e.hasOwnProperty('imageLauncher') && e.imageLauncher !== "";
            });

            GameAdBannerModel.allAds[gameId].sort(function(a, b) {
                return b.priority - a.priority;
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
