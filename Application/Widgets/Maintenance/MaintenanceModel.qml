import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.ServerTime 1.0

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
        var currentTime = ((+Date.now()) / 1000),
            startTime,
            endTime,
            index,
            item,
            gameId,
            s,
            itemExist,
            nearestInterval = 2294967296;

        MaintenanceModel.schedule = {};

        // INFO В Qt/QML есть баг с храненим строковых ключей мап похожих на число. Они приводятся к int32
        // и отбрасывается старший байт (5ый).
        for (index in schedule) {
            s = schedule[index];

            gameId = s.gameId;
            endTime = s.endDate;

            item = App.serviceItemByServiceId(gameId);
            if (!item) {
                continue;
            }

            item.maintenanceSettings = {
                    "title": s.title || "",
                    "newsTitle": s.newsTitle || "",
                    "newsText": s.newsText || "",
                    "newsLink": s.newsLink || "",
                    "isSticky": s.isSticky
                }

            if (item.ignoreMaintenance) {
                item.maintenance = false;
                item.maintenanceInterval = 0;
                continue;
            }

            startTime = s.startDate;

            if (endTime < currentTime) {
                item.maintenance = false;
                item.maintenanceInterval = 0;

                if (MaintenanceModel.showMaintenanceEnd[gameId]) {
                    delete MaintenanceModel.showMaintenanceEnd[gameId];

                    if (!App.isWindowVisible()
                        && AppSettings.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true)) {
                        root.showPopupGameMaintenanceEnd(index);
                    }
                }

                continue;
            }

            MaintenanceModel.schedule[gameId] = s;

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

        RestApi.Games.getMaintenance(function(code, response) {
            var schedule = response.map(function(e) {
                return {
                    gameId: e.game.id,

                    startDate: ServerTime.correctTime( (+(new Date(e.startDate))) / 1000),
                    endDate: ServerTime.correctTime( (+(new Date(e.endDate))) / 1000),

                    "title": e.title || "",
                    "newsTitle": e.newsTitle || "",
                    "newsText": e.newsText || "",
                    "newsLink": e.newsLink || "",
                    "isSticky": !!e.isSticky
                }
            });

            root.update(schedule);
            callcb();
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
