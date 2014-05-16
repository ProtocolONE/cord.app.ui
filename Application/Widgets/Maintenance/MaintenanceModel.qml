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
import "../../../js/restapi.js" as RestApi
import "../../../js/Core.js" as Core
import "MaintenanceModel.js" as MaintenanceModel

WidgetModel {
    function update(schedule) {
        var currentTime = +new Date(),
            startTime,
            endTime,
            multiplier,
            index,
            item,
            itemExist,
            nearestInterval = 2294967296;

        MaintenanceModel.schedule = {};
        console.log('schedule', JSON.stringify(schedule));

        for (index in schedule) {
            multiplier = schedule[index].hasOwnProperty('id') ? 1000 : 1;
            endTime = schedule[index].endTime * multiplier;

            item = Core.serviceItemByServiceId(index);
            if (!item) {
                continue;
            }

            startTime = schedule[index].startTime * multiplier;

            //INFO maintenanceEndPause корректно отработает и выключился, потому, что будет вызван из maintCheck, т.о. состояние
            //"паузы" после профилактики продлится минимум от получаса до 90 минут.
            item.maintenanceEndPause = (currentTime >= startTime) && (currentTime < (endTime + (1800 * multiplier)));

            if (endTime < currentTime) {
                if (item.maintenance) {
                    Core.gameMaintenanceEnd(index);
                }

                item.maintenance = false;
                item.maintenanceInterval = 0;

                continue;
            }

            MaintenanceModel.schedule[index] = {
                startTime: startTime,
                endTime: endTime
            };

            var maintenance = currentTime >= startTime && currentTime < endTime;
            if (item.maintenance && !maintenance) {
                Core.gameMaintenanceEnd(index);
            }
            if (!item.maintenance && maintenance) {
                Core.gameMaintenanceStart(index);
            }

            item.maintenance = maintenance;
            item.maintenanceInterval = Math.round((endTime - currentTime) / 1000);

            nearestInterval = Math.min(nearestInterval, startTime - currentTime);
        }

        if (nearestInterval > maintCheck.interval) {
            scheduleTick.stop();
            return;
        }

        scheduleTick.interval = nearestInterval > 0 ? nearestInterval : 1000;
        if (!scheduleTick.running) {
            scheduleTick.start();
        }
    }

    Component.onCompleted: maintCheck.start();

    Timer {
        id: maintCheck

        function rand(min, max) {
            return min + (Math.random() * (max - min)) | 0;
        }

        interval: scheduleTick.running ? rand(300000, 600000) : rand(1800000, 5400000) //10-20 min or 30 - 90 min
        onIntervalChanged: console.log('Maintenance interval: ' + interval)
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            RestApi.Games.getMaintenance(function(response) {
                                             if (!response.hasOwnProperty('schedule')) {
                                                 return;
                                             }

                                             update(response.schedule);
                                         });
        }
    }

    Timer {
        id: scheduleTick

        repeat: true
        onTriggered: {
            var temp = MaintenanceModel.schedule;
            update(temp);
        }
    }
}
