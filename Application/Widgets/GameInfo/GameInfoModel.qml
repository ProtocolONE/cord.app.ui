import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

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

        RestApi.Games.getGallery(gameId, function(code, response) {
            if (!RestApi.ErrorEx.isSuccess(code) || response.length === 0) {
                return;
            }

            GameInfoModel.allInfo[gameId] = Lodash._.chain(response)
            .filter(function(e) {
                return !!e.image || !!e.mp4;
            })
            .map(function(e) {
                var type = 0;
                if (!!e.mp4) {
                    type = 1;
                }

                return {
                    "id": e.id,
                    "type": type,
                    "index": 0,
                    "preview": e.preview || "",
                    "source": type === 0 ? (e.image || "") : (e.mp4 || ""),
                }
            })
            .sortBy('type')
            .reverse()
            .value();

            root.infoChanged();
        });
    }
}
