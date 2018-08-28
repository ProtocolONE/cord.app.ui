import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

import "GameInfoModel.js" as GameInfoModel

WidgetModel {
    id: root

    signal infoChanged();

    function getGallery(gameId) {
        if (GameInfoModel.allInfo.hasOwnProperty(gameId)) {
            return GameInfoModel.allInfo[gameId];
        }
    }

    function refreshGallery(gameId) {
        if (GameInfoModel.allInfo.hasOwnProperty(gameId)) {
            root.infoChanged();
            return;
        }

        RestApi.Games.getGallery(gameId, function(response) {
            if (!response || !response.hasOwnProperty('gallery')) {
                return;
            }

            var galleries = Object.keys(response.gallery).map(function(e) {
                //INFO Due to php realization of serialization `getGallery` response could be object with one key if
                //we have just one gallery. So make small trick to remove this issue.
                return response.gallery[e];
            });

            if (galleries.length > 1) {
                galleries = galleries.filter(function(e) {
                    return e.category.name == "Скриншоты";
                });
            }

            if (galleries.length == 0) {
                return;
            }

            GameInfoModel.allInfo[gameId] = Lodash._.chain(galleries[0].media)
                .filter(function(e) {
                    var type = e.type|0;
                    return type === 0 || (type === 1 && !!e.rawSource);
                })
                .map(function(e) {
                    var type = e.type|0;
                    return {
                        "id": e.id|0,
                        "category": e.category|0,
                        "type": type,
                        "index": e.index|0,
                        "preview": e.preview || "",
                        "source": type === 0 ? (e.source || "") : (e.rawSource || ""),
                    }
                })
                .sortBy('type')
                .reverse()
                .sortBy('index')
                .value();

            root.infoChanged();
        }, function() {
            console.log('RestApi.Games.getGallery() method failed.');
            root.infoChanged();
        });
    }
}
