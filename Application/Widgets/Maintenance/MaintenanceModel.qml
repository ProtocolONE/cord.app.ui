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
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0

import "MaintenanceModel.js" as MaintenanceModel
import "View" as View

WidgetModel {
    id: root

    Component {
        id: gameMaintenanceEndPopUp

        View.MaintenanceEnd {
            id: popUp
        }
    }

    Connections {
        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

        onDownloaderFinished: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service)
                return;
            }

            if (item.maintenance) {
                 MaintenanceModel.showMaintenanceEnd[service] = 1;
            }
        }
    }

    function showPopupGameMaintenanceEnd(serviceId) {
        var gameItem = App.serviceItemByServiceId(serviceId)
            , popUpOptions;

        popUpOptions = {
            gameItem: gameItem,
            buttonCaption: qsTr('POPUP_PLAY'),
            message: qsTr('POPUP_MAINTENANCE_END_AND_READY_TO_START')
        };

        TrayPopup.showPopup(gameMaintenanceEndPopUp, popUpOptions, 'gameMaintenanceEndShow' + serviceId);
        Ga.trackEvent('Announcement GameMaintenanceEndShow', 'show', gameItem.gaName);
    }

    function update(schedule) {
        var currentTime = maintCheck.getTime(),
            startTime,
            endTime,
            multiplier,
            index,
            item,
            itemExist,
            nearestInterval = 2294967296;

        MaintenanceModel.schedule = {};

        for (index in schedule) {
            multiplier = schedule[index].hasOwnProperty('id') ? 1000 : 1;
            endTime = schedule[index].endTime * multiplier;

            item = App.serviceItemByServiceId(index);
            if (!item) {
                continue;
            }

            if (item.ignoreMaintenance) {
                item.maintenance = false;
                item.maintenanceInterval = 0;
                continue;
            }

            startTime = schedule[index].startTime * multiplier;

            //INFO maintenanceEndPause корректно отработает и выключился, потому, что будет вызван из maintCheck, т.о. состояние
            //"паузы" после профилактики продлится минимум от получаса до 90 минут.
            item.maintenanceEndPause = (currentTime >= startTime) && (currentTime < (endTime + (1800 * multiplier)));

            if (endTime < currentTime) {
                item.maintenance = false;
                item.maintenanceInterval = 0;

                if (MaintenanceModel.showMaintenanceEnd[index]) {
                    delete MaintenanceModel.showMaintenanceEnd[index];

                    if (!App.isWindowVisible() && AppSettings.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true)) {
                        root.showPopupGameMaintenanceEnd(index);
                    }
                }

                continue;
            }

            MaintenanceModel.schedule[index] = {
                startTime: startTime,
                endTime: endTime
            };

            var maintenance = currentTime >= startTime && currentTime < endTime;

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

        property int diff: 0

        function getTime() {
            return Date.now() + maintCheck.diff;
        }

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

                RestApi.Core.execute('misc.getTime', {}, false, function(data) {
                    var time;
                    if (data.hasOwnProperty('atom')) {
                        time = Moment.moment(new Date(data.atom));
                        maintCheck.diff = Moment.moment.duration(time.diff(new Date())).asMilliseconds();
                    }

                    update(response.schedule);
                }, function(){
                    update(response.schedule);
                });
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

    Shortcut {
        key: "Ctrl+Shift+M"
        onActivated: {
            var currentGame = App.currentGame();
            if (!currentGame) {
                return;
            }

            currentGame.ignoreMaintenance = !currentGame.ignoreMaintenance;
        }
    }
}
