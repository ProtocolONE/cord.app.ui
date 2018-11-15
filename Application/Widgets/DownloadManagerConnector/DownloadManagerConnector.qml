import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import Application.Blocks 1.0
import Application.Core 1.0
import Application.Core.MyGames 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0
import Application.Models 1.0

import "./DownloadManagerConnector.js" as DownloadManagerConnector

WidgetModel {
    id: root

    property bool firstDownload: true
    property bool shouldShowInstallPopup: false

    settings: WidgetSettings {
        namespace: 'DownloadManagerConnector'

        property bool gameUpdateFinishedNotification: true
    }

    QtObject {
        id: d

        function calcDimension(value) {
            if (value < 999900) {
                return qsTr('%1 KB').arg((value / 1024).toFixed(1));
            }

            if (value < 999990000) {
                return qsTr('%1 MB').arg((value / 1048576).toFixed(1));
            }

            return qsTr('%1 GB').arg((value / 1073741824).toFixed(2));
        }
    }

    function showPopupGameInstalled(serviceId) {
        if (!root.settings.gameUpdateFinishedNotification) {
            return;
        }

        var gameItem = App.serviceItemByServiceId(serviceId)
        , popUpOptions;

        popUpOptions = {
            gameItem: gameItem,
            buttonCaption: qsTr('POPUP_PLAY'),
            message: qsTr('POPUP_READY_TO_START')
        };

        TrayPopup.showPopup(gameInstalledPopUp, popUpOptions, 'gameInstalled' + serviceId);
        Ga.trackEvent('Announcement GameInstalled', 'show', gameItem.gaName);
    }

    function checkMaintenance(service, recheck, showInfo) {
        var target = service;
        var maint = WidgetManager.getWidgetByName('Maintenance');
        if (!maint) {
            root.afterMaintenanceUpdated(target, recheck, showInfo);
            return;
        }

        maint.model.requestMaintenanceData(function() {
            root.afterMaintenanceUpdated(target, recheck, showInfo);
        })
    }

    function afterMaintenanceUpdated(service, recheck, showInfo) {
        var item = App.serviceItemByServiceId(service);
        if (!item) {
            console.log('Unknown service ' + service);
            return;
        }

        if (item.maintenance) {
            SignalBus.progressChanged(item);
            App.activateGameByServiceId(service);
            SignalBus.navigate("mygame", '');
            return;
        }

        var targetServiceId = service; // без этого замыканяи ломается колбек MessageShow

        var isPopUpCase = (App.isWindowVisible() && App.currentGame() !== item);

        if (root.shouldShowInstallPopup) {
            root.shouldShowInstallPopup = false;
            isPopUpCase = true;
        }

        var currentGame = App.currentGame();
        var canExecuting = !item.firstDownload || ((currentGame ? (currentGame.gameId === item.gameId) : false) && App.isWindowVisible());

        if (!canExecuting || isPopUpCase || !User.isAuthorized()) {
            item.status = "Normal";
            item.statusText = '';
            SignalBus.progressChanged(item);
            root.showPopupGameInstalled(service);
            return;
        }

        App.activateWindow();
        App.activateGameByServiceId(service);

        SignalBus.progressChanged(item);

        if (!recheck)
            Popup.show('GameExecuting', '', 1);
        else if (showInfo)
            MessageBox.show(qsTr("REFRESH_INFO"), qsTr("REFRESH_MESSAGE"), MessageBox.button.ok);
    }

    Connections { // прогрев статуса установки
        target: App.mainWindowInstance()

        ignoreUnknownSignals: true

        onAuthBeforeStartGameRequest: {
            App.activateWindow();
            console.log('authBeforeStartGameRequest', serviceId);
        }

        onServiceInstalled: {
            var item = App.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId);
                return;
            }

            SignalBus.serviceInstalled(item);
        }

        onServiceStarted: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            if (item.gameType == 'browser') {
                MyGames.setShowInMyGames(item.serviceId, true);
            }

            App.serviceStarted(service);
            item.status = "Started";
            item.statusText = qsTr("TEXT_PROGRESSBAR_NOW_PLAYING_STATE");
            console.log("onServiceStarted " + service);

            SignalBus.progressChanged(item);
            SignalBus.serviceStarted(item);
        }

        onServiceFinished: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            App.serviceStopped(service);

            item.status = "Finished"; //(Может и ошибку надо выставлять в случаи не успех)
            item.statusText = "";
            console.log("onServiceFinished " + service + " with state " + serviceState);

            SignalBus.progressChanged(item);
            SignalBus.serviceFinished(item);
        }

        onDownloaderStarted: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            item.firstDownload = !ApplicationStatistic.isServiceInstalled(item.serviceId);

            if (startType === DownloadManagerConnector.StartType.Uninstall) {
                item.status = "Uninstalling";
                App.activateGame(item);
                SignalBus.navigate("mygame", '');
                Popup.show('GameUninstall');

                MyGames.setShowInMyGames(item.serviceId, false);
                SignalBus.uninstallStarted(service);
            } else {
                item.status = "Downloading";
                item.allreadyDownloaded = false;
                item.recheck = startType === DownloadManagerConnector.StartType.Recheck;

                console.log("START DOWNLOAD");

                MyGames.setShowInMyGames(item.serviceId, true);
                SignalBus.progressChanged(item);
                SignalBus.downloaderStarted(item);

                if (root.firstDownload) {
                    root.firstDownload = false;
                }
            }
        }

        onDownloaderStopped: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            item.status = DownloadManagerConnector.hasAcces(service) ? "Paused" : "Normal";
            DownloadManagerConnector.resetAccess(service);
            console.log("DOWNLOAD STOPPED");

            SignalBus.progressChanged(item);
        }

        onDownloaderStopping: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            item.status = "Paused";
            console.log("DOWNLOAD STOPPING");

            SignalBus.progressChanged(item);
        }

        onDownloaderFailed: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            item.status = "Error";
            item.statusText = "";
            item.recheck = false;
            console.log("DOWNLOAD FAILED");

            App.activateGameByServiceId(service);
            SignalBus.navigate('mygame', 'GameItem');
            SignalBus.progressChanged(item);
        }

        onDownloaderFinished: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            item.statusText = "";
            item.progress = 100;

            if (item.status === "Uninstalling") {
                item.status = "Normal";
                item.allreadyDownloaded = false;
                item.isInstalled = false;
                SignalBus.progressChanged(item);
                SignalBus.uninstallFinished(service);
                return;
            }

            var recheck = !!(item.recheck || item.noRun);
            var showInfo = item.showInfo;

            console.log("DOWNLOAD FINISHED", item.maintenance);
            item.status = "Normal";
            item.allreadyDownloaded = true;
            item.isInstalled = true;
            item.recheck = false;
            item.noRun = false;
            item.showInfo = false;

            root.checkMaintenance(service, recheck, showInfo);
        }

        onTotalProgressChanged: {
            var item = App.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId);
                return;
            }

            item.progress = progress;

            if (item.status == "Uninstalling") {
                SignalBus.uninstallProgressChanged(serviceId, progress);
            }

            SignalBus.progressChanged(item);
        }

        onRehashProgressChanged: {
            var item = App.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId);
                return;
            }

            item.progress = progress;
            item.statusText = qsTr("TEXT_PROGRESSBAR_REHASH_NOW_STATE").arg(rehashProgress);

            SignalBus.progressChanged(item);
        }

        onDownloadProgressChanged: {
            var item = App.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('Unknown service ' + serviceId);
                return;
            }

            var isInstalled = ApplicationStatistic.isServiceInstalled(serviceId);
            item.progress = progress;
            item.statusText = (isInstalled ? qsTr("TEXT_PROGRESSBAR_UPDATING_NOW_STATE") :
                                             qsTr("TEXT_PROGRESSBAR_DOWNLOADING_NOW_STATE"))
            .arg(d.calcDimension(totalWantedDone))
            .arg(d.calcDimension(totalWanted));

            SignalBus.progressChanged(item);
        }

        onDownloaderServiceStatusMessageChanged: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('onDownloaderServiceStatusMessageChanged item not found ' + service);
                return;
            }

            item.statusText = message;

            SignalBus.progressChanged(item);
        }

        onSecondServiceFinished: {
            var item = App.serviceItemByServiceId(service);
            if (!item) {
                console.log('Unknown service ' + service);
                return;
            }

            item.secondStatus = "Normal"; //(Может и ошибку надо выставлять в случаи не успех)
        }

        onGameDownloaderAccessRequired: {
            var service = App.serviceItemByServiceId(serviceId);
            if (service.isStandalone) {
                SignalBus.buyGame(serviceId);
                return;
            }

            DownloadManagerConnector.setHasNoAccess(serviceId);
            Popup.show('PromoCode');
        }
    }

    Connections {
        target: SignalBus

        ignoreUnknownSignals: true

        onServicesLoaded: {
            var item;
            for (var i = 0; i < Games.count; i++) {
                item = Games.get(i);
                item.isInstalled = ApplicationStatistic.isServiceInstalled(item.serviceId);
            }
        }
    }

    Component {
        id: gameInstalledPopUp

        GamePopup {
            id: popUp

            function gaEvent(name) {
                Ga.trackEvent('Announcement GameInstalled', name, gameItem.gaName);
            }

            Connections {
                target: App.mainWindowInstance()
                ignoreUnknownSignals: true
                onServiceStarted: {
                    if (gameItem.serviceId == service) {
                        shadowDestroy();
                    }
                }
            }

            onAnywhereClicked: {

                gaEvent('miss click');
                App.activateGame(gameItem);
                SignalBus.navigate("mygame", '')
                App.activateWindow();
            }
            onTimeoutClosed: gaEvent('timeout close')
            onCloseButtonClicked: gaEvent('close')
            onPlayClicked: {
                gaEvent('play');
                if (!User.isAuthorized()){
                    return;
                }

                App.activateGame(gameItem);
                SignalBus.navigate("mygame", '')
                App.downloadButtonStart(gameItem.serviceId);
            }
        }
    }
}
