import QtQuick 1.1

import "Maintenance.js" as Helper
import "../../js/restapi.js" as RestApi
import "../../js/Core.js" as Core
import "../../js/GoogleAnalytics.js" as GoogleAnalytics
import "../../js/PopupHelper.js" as PopupHelper
import "PopUp" as PopUp

Item {
    Component.onCompleted: maintCheck.start();


    Component {
        id: gameMaintenanceEndPopUp

        PopUp.MaintenanceEnd {
            id: popUp
        }
    }

    function showPopupGameMaintenanceEnd(serviceId) {
        var gameItem = Core.serviceItemByServiceId(serviceId)
            , popUpOptions;

        popUpOptions = {
            gameItem: gameItem,
            buttonCaption: qsTr('POPUP_PLAY'),
            message: qsTr('POPUP_MAINTENANCE_END_AND_READY_TO_START')
        };

        PopupHelper.showPopup(gameMaintenanceEndPopUp, popUpOptions, 'gameMaintenanceEndShow' + serviceId);
        GoogleAnalytics.trackEvent('/announcement/gameMaintenanceEndShow/' + gameItem.serviceId,
                                   'Announcement', 'Show Announcement', gameItem.gaName);
    }

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

            startTime = schedule[index].startTime * multiplier;

            //INFO maintenanceEndPause корректно отработает и выключился, потому, что будет вызван из maintCheck, т.о. состояние
            //"паузы" после профилактики продлится минимум от получаса до 90 минут.
            item.maintenanceEndPause = (currentTime >= startTime) && (currentTime < (endTime + (1800 * multiplier)));

            if (endTime < currentTime) {
                item.maintenance = false;
                item.maintenanceInterval = 0;

                if (Helper.showMaintenanceEnd[index]) {
                    delete Helper.showMaintenanceEnd[index];

                    if (!mainWindow.visible && Helper.isShowEndPopup()) {
                        showPopupGameMaintenanceEnd(index);
                    }
                }

                continue;
            }

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
