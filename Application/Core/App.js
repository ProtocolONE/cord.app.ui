.pragma library
/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

/**
 * App.js is an facade object for c++ host application proxy, qml signalbus object.
 */
var indexToGameItem = {},
    gameIdToGameItem = {},
    serviceIdToGameItemIdex = {},
    serviceStartButtonClicked = {},
    servicesGrid,
    authAccepted = false,
    count = 0,
    clientWidth = 1000,
    clientHeight = 600;

/**
 * Import modules
 */
Qt.include('./Modules/SignalBus.js');
Qt.include('./Modules/Host.js');
Qt.include('./Modules/Settings.js');
Qt.include('./Modules/Overlay.js');
Qt.include('./Modules/ServiceHandleModel.js');
Qt.include('./Modules/ApplicationStatistic.js');
Qt.include('./Modules/Service.js');

var gamesListModel = initModel(),
    _gamesListModelList,
    _previousGame = gamesListModel.currentGameItem;

function initModel() {
    var component = Qt.createComponent('../Models/GamesListModel.qml');

    if (component.status != 1) {
        console.log('FATAL: error loading model:', component.errorString());
        return null;
    }

    _gamesListModelList = component.createObject(null);
    if (!_gamesListModelList) {
        console.log('FATAL: error creating model');
        return null;
    }

    return _gamesListModelList;
}

function fillGamesModel(data) {
        var i,
            item,
            last,
            isGameNetItem,
            isItemShouldBeShown;

        count = data.length;

        _gamesListModelList.clear();

        for (i = 0; i < count; ++i) {
            item = createService(data[i]);

            if (!item) {
                 continue;
            }

            isGameNetItem = (item.serviceId == '0');
            isItemShouldBeShown = isPrivateTestVersion() || item.isPublishedInApp || isGameNetItem;

            if (!isItemShouldBeShown) {
                 continue;
            }

            _gamesListModelList.fillMenu(item);
            _gamesListModelList.append(item);

            last = _gamesListModelList.count - 1;
            indexToGameItem[i] = _gamesListModelList.get(last);
            gameIdToGameItem[item.gameId] = _gamesListModelList.get(last);
            serviceIdToGameItemIdex[item.serviceId] = i;
        }
}

function currentRunningMainService() {
    var serviceItem;
    for (var i = 0; i < gamesListModel.count; i++) {
        serviceItem = gamesListModel.get(i);

        if (serviceItem.status === "Started" || serviceItem.status === "Starting") {
            return serviceItem.serviceId;
        }
    }
}

function currentRunningSecondService() {
    var serviceItem;
    for (var i = 0; i < gamesListModel.count; i++) {
        serviceItem = gamesListModel.get(i);

        if (serviceItem.secondStatus === "Started" || serviceItem.secondStatus === "Starting") {
            return serviceItem.serviceId;
        }
    }
}

function isAnyServiceLocked() {
    var serviceItem;
    for (var i = 0; i < gamesListModel.count; i++) {
        serviceItem = gamesListModel.get(i);

        if (serviceItem.locked) {
            return true;
        }
    }

    return false;
}


function activateGame(item) {
    _previousGame = gamesListModel.currentGameItem;
    gamesListModel.currentGameItem = item;
}

function previousGame(item) {
    return _previousGame;
}

function activateGameByServiceId(serviceId) {
    var item = serviceItemByServiceId(serviceId);

    if (!item)
        return;

    activateGame(item);
}

function currentGame() {
    return gamesListModel.currentGameItem;
}

function serviceItemByIndex(index) {
    return indexToGameItem[index];
}

function serviceItemByGameId(gameId) {
    return gameIdToGameItem[gameId];
}

function serviceItemByServiceId(serviceId) {
    var index = indexByServiceId(serviceId)
    return index != undefined ? indexToGameItem[index] : undefined;
}

function indexByServiceId(serviceId) {
    return serviceIdToGameItemIdex[serviceId];
}

function serviceExists(serviceId) {
    return serviceIdToGameItemIdex.hasOwnProperty(serviceId);
}

function gameExists(gameId) {
    return gameIdToGameItem.hasOwnProperty(gameId);
}

function startingService() {
    var serviceId = startingServiceUnsafe();
    return serviceExists(serviceId) ? serviceId : "0";
}

/**
 * Application specific functions
 */
function replenishAccount() {
    openExternalUrlWithAuth("https://www.gamenet.ru/money");
}

var runningService = {},
    runningSecondService = {};

function isAnySecondServiceRunning() {
    return _signalBusInst.isAnySecondServiceRunning;
}

function secondServiceStarted(service) {
    runningSecondService[service] = 1;
    _signalBusInstance.isAnySecondServiceRunning = true;
}

function secondServiceFinished(service) {
    delete runningSecondService[service];
    _signalBusInstance.isAnySecondServiceRunning = Object.keys(runningSecondService).length > 0;
}

function getRegisteredServices() {
    return Object.keys(serviceIdToGameItemIdex);
}

function isMyGamesEnabled() {
    var count = 0;

    if (Object.keys(serviceStartButtonClicked).length >= 2) {
        return true;
    }

    for (var i = 0; i < gamesListModel.count; ++i) {
        var item = gamesListModel.get(i);

        if (isShownInMyGames(item.serviceId)) {
            count ++;
        }

        if (count >= 2) {
            return true;
        }
    }

    return false;
}

function isShownInMyGames(serviceId) {
    if (serviceStartButtonClicked[serviceId]) {
        return true;
    }

    return settingsValue("gameInstallBlock/serviceStartButtonOnceClicked", serviceId, 0) == 1;
}

function setShowInMyGames(serviceId, value) {
    if (value && !serviceStartButtonClicked.hasOwnProperty(serviceId)) {
        setSettingsValue("gameInstallBlock/serviceStartButtonOnceClicked", serviceId, 1);
        serviceStartButtonClicked[serviceId] = true;
        serviceUpdated(serviceItemByServiceId(serviceId));
    }

    if (!value && serviceStartButtonClicked.hasOwnProperty(serviceId)) {
        setSettingsValue("gameInstallBlock/serviceStartButtonOnceClicked", serviceId, 0);
        delete serviceStartButtonClicked[serviceId];
        serviceUpdated(serviceItemByServiceId(serviceId));
    }
}

function isMainServiceCanBeStarted(item) {
    if (!item) {
        return false;
    }

    if (item.gameType == "browser") {
        return true;
    }

    if (isAnyServiceLocked()) {
        return false;
    }

    var currentMainRunning = currentRunningMainService(),
        currentSecondRunning = currentRunningSecondService();

    if (currentMainRunning ||
       (currentSecondRunning && currentSecondRunning != item.serviceId)) {
        return false;
    }

    return true;
}
