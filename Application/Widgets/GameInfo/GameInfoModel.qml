/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import "GameInfoModel.js" as GameInfoModel
import Application.Core 1.0

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

            var shownCategoryId;

            Object.keys(response.gallery).forEach(function(e) {
                var item = response.gallery[e].category;
                if (item.name == "Скриншоты") {
                    shownCategoryId = item.id;
                }
            });

            var data = response.gallery.filter(function(e) {
                return e.category.id == shownCategoryId;
            });

            GameInfoModel.allInfo[gameId] = data[0].media.map(function(e) {
                return {
                    "id": e.id|0,
                    "category": e.category|0,
                    "type": e.type|0,
                    "index": e.index|0,
                    "preview": e.preview || "",
                    "source": e.source || ""
                };
            });

            root.infoChanged();
        }, function() {
            console.log('RestApi.Games.getGallery() method failed.');
            root.infoChanged();
        });
    }
}
