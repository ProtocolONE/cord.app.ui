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
import GameNet.Components.Widgets 1.0
import GameNet.Core 1.0

WidgetModel {
    id: rootModel

    property variant news

    function reloadNews() {
        RestApi.Wall.getNews( function(news) {
            rootModel.news = news;
        }, function(){});
    }

    function updateNewsByPush(elem) {
        if (!!news) {
            return;          
        }

        var sNumTime = elem.time;
        var pushElem = {sNumTime : elem};

        Lodash._.assign(news, pushElem);
    }

    Component.onCompleted: refreshNewsTimer.start()

    Timer {
        id: refreshNewsTimer

        //INFO from 15 to 60 minutes
        interval: 900000 + Math.floor(Math.random() * 2700000)
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            console.log('Reloading news block');
            rootModel.reloadNews();
        }
    }
}
