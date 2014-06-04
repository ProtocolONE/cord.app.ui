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

import "../../Core/restapi.js" as RestApiJs
import "GameInfoModel.js" as GameInfoModel

WidgetModel {
    id: root

    signal infoChanged();

    function getInfo(gameId) {
        if (GameInfoModel.allInfo.hasOwnProperty(gameId)) {
            return GameInfoModel.allInfo[gameId];
        }
    }

    //  DEBUG
    Component.onCompleted: {
        GameInfoModel.allInfo["92"] = "Combat Arms - онлайн-шутер с самым большим выбором оружия и экипировки; Combat Arms - онлайн-шутер с самым большим выбором оружия и экипировки; Combat Arms - онлайн-шутер с самым большим выбором оружия и экипировки";
        GameInfoModel.allInfo["71"] = "BS.ru Demonion - это увлекательная онлайн игра, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие, которая заслужила доверие ...";
    }
    //  END DEBUG

    Timer {
        interval: 900000 //each 30 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
//            RestApiJs.Games.getInfos(function(response) {
//                if (!response.hasOwnProperty('infos')) {
//                    return;
//                }

//                for (var i = 0; i < response.infos.length; i++) {
//                    GameInfoModel.allInfo[response.infos[i].gameId] = response.infos[i].text;
//                }
//                root.infoChanged();
//            });
        }
    }
}
