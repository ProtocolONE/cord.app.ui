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

    property variant dataSource
    property variant gameItem: App.currentGame()

    onGameItemChanged: timer.restart();

    Timer {
        id: timer

        interval: 900000 //each 30 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!root.gameItem) {
                return;
            }

            console.log("GameInfoModel timer triggered!");

            RestApi.Games.getGallery(root.gameItem.gameId, function(response) {
                if (!response || !response.hasOwnProperty('gallery')) {
                    return;
                }

                var shownCategory;

                Object.keys(response.gallery).forEach(function(e) {
                    var item = response.gallery[e].category;
                    if (item.name == "Скриншоты") {
                        shownCategory = item.id;
                    }
                });

                var data = response.gallery.filter(function(e) {
                    return e.category.id == shownCategory;
                });

                root.dataSource = data[0].media;

            }, function() {
                console.log('failed callback')
            });
        }
    }
}
