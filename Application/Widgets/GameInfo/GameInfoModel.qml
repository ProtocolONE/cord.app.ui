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

import "../../Core/restapi.js" as RestApi
import "GameInfoModel.js" as GameInfoModel
import "../../Core/App.js" as App

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

            GameInfoModel.allInfo[gameId] = data[0].media;

            root.infoChanged();
        }, function() {
            console.log('RestApi.Games.getGallery() method failed.');
            root.infoChanged();
        });
    }
}
