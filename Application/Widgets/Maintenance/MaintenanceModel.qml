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
            index,
            index_fake,
            item,
            itemExist,
            nearestInterval = 2294967296;

        MaintenanceModel.schedule = {};

        // INFO В Qt/QML есть баг с храненим строковых ключей мап похожих на число. Они приводятся к int32
        // и отбрасывается старший байт (5ый).
        for (index_fake in schedule) {
            index = schedule[index_fake].id;
            endTime = schedule[index].endTime;

            item = App.serviceItemByServiceId(index);
            if (!item) {
                continue;
            }

            item.maintenanceSettings = {
                    "title": schedule[index].title || "",
                    "newsTitle": schedule[index].newsTitle || "",
                    "newsText": schedule[index].newsText || "",
                    "newsLink": schedule[index].newsLink || "",
                    "isSticky": !!schedule[index].isSticky
                }

            if (item.ignoreMaintenance) {
                item.maintenance = false;
                item.maintenanceInterval = 0;
                continue;
            }

            startTime = schedule[index].startTime;

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

            MaintenanceModel.schedule[index] = schedule[index]

            var maintenance = currentTime >= startTime && currentTime < endTime;

            item.maintenance = maintenance;
            item.maintenanceInterval = Math.round((endTime - currentTime));

            nearestInterval = Math.min(nearestInterval, startTime - currentTime);
        }

        if ((nearestInterval*1000) > maintCheck.interval) {
            scheduleTick.stop();
            return;
        }

        scheduleTick.interval = nearestInterval > 0 ? (nearestInterval*1000) : 1000;
        if (!scheduleTick.running) {
            scheduleTick.start();
        }
    }

    function requestMaintenanceData(cb) {
        function callcb() {
            if (cb) {
                cb();
            }
        }

        RestApi.Games.getMaintenance(function(response) {
            if (!response.hasOwnProperty('schedule')) {
                callcb();
                return;
            }

            RestApi.Misc.getTime(function(data) {
                var time;
                if (data.hasOwnProperty('atom')) {
                    time = Moment.moment(new Date(data.atom));
                    maintCheck.diff = Moment.moment.duration(time.diff(new Date())).asMilliseconds();
                }

                update(response.schedule);
                callcb();
            }, function(){
                update(response.schedule);
                callcb();
            });
        });
    }

    Connections {
        target: SignalBus

        ignoreUnknownSignals: true

        onServicesLoaded: {
            maintCheck.start();
        }
    }

    Timer {
        id: maintCheck

        property int diff: 0

        function getTime() {
            return (((Date.now() + maintCheck.diff) / 1000)|0) ;
        }

        function rand(min, max) {
            return min + (Math.random() * (max - min)) | 0;
        }

        interval: scheduleTick.running ? rand(300000, 600000) : rand(1800000, 5400000) //10-20 min or 30 - 90 min
        onIntervalChanged: console.log('Maintenance interval: ' + interval)
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            requestMaintenanceData()
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
