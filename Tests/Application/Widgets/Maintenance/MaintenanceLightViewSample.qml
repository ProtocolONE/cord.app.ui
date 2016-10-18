/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4

import Dev 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

import ".."

Rectangle {
    width: 800
    height: 800
    color: '#cccccc'



    Component.onCompleted:  {
        Styles.init();
        Styles.setCurrentStyle("main")

        RestApi.Games.getMaintenance = function(callback) {
            var schedule = {
                    "300006010000000000": {
                      "id": "300006010000000000",
                      "startTime": 1436936400,
                      "endTime": 1436950800,

                    "title":  "Технические работы окончатся через gggg",
                    "newsTitle": "Заголовок новости",
                    "newsLink":  "https://gamenet.ru/games/phantomers/post/1iorr7/",
                    "newsText": "18 октября, с 8:00 до 12:00 часов по московскому времени серверы игры Phantomers будут остановлены для проведения плановых технических работ. В это время игра будет недоступна.
    В ходе технических работ будет проведено обслуживание серверной части и программного обеспечения.
    Приносим извинения за возможные неудобства.",
                    "isSticky" : true
                    }
              };

            var fakeEnd = ((Date.now()/1000)|0) + (000)*(24*3600) + (23)*3600 + (59)*60;
            var fakeStart = ((Date.now()/1000)|0) + (-1)*3600;

            console.log('fake time ', Date.now(),((Date.now()/1000)|0),  fakeStart, fakeEnd)

            schedule["300006010000000000"].startTime = fakeStart;
            schedule["300006010000000000"].endTime = fakeEnd;

            console.log('FakeRestApiResponse:')
            console.log(JSON.stringify(schedule, null ,2))

            callback({schedule: schedule});
        }

        WidgetManager.registerWidget('Application.Widgets.Maintenance');
        WidgetManager.init();
    }

    RequestServices {
        onReady: {
            SignalBus.servicesLoaded();

            var item = App.serviceItemByGameId("84");
            console.log('//////', item.gameId)
            App.activateGame(item);
            widget.visible = true;
        }
    }

    WidgetContainer {
        id: widget

        x: 50
        y: 50

        visible: false
        width: 590
        height: 100
        widget: visible ? 'Maintenance': ""
        view: 'MaintenanceLightView'
    }
}
