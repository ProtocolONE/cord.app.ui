import QtQuick 1.1

import "MaintenanceHelper.js" as Helper

import "../../js/restapi.js" as RestApi
import "../../js/Core.js" as Core

Item {
    Component.onCompleted: maintCheck.start();

    function update(schedule) {
        var currentTime = +new Date(),
            startTime,
            endTime,
            multiplier,
            index,
            item,
            itemExist,
            nearestInterval = 2294967296;

        Helper.schedule = {};
        for (index in schedule) {
            multiplier = schedule[index].hasOwnProperty('id') ? 1000 : 1;
            endTime = schedule[index].endTime * multiplier;

            item = Core.serviceItemByServiceId(index);
            if (!item) {
                continue;
            }

            if (endTime < currentTime) {
                item.maintenance = false;
                item.maintenanceInterval = 0;
                continue;
            }

            startTime = schedule[index].startTime * multiplier;

            Helper.schedule[index] = {
                startTime: startTime,
                endTime: endTime
            };


            item.maintenance = currentTime >= startTime && currentTime < endTime;
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
            var temp = Helper.schedule;
            update(temp);
        }
    }
}
