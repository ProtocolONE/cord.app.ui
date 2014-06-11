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
    authAccepted = true, // tmp
    count = 0,
    clientWidth = 1000,
    clientHeight = 600;

/**
 * Import modules
 */
Qt.include('./Modules/SignalBus.js');
Qt.include('./Modules/Host.js');
Qt.include('./Modules/Settings.js');

var gamesListModel = initModel(),
    _previousGame = gamesListModel.currentGameItem,
    gamenetGameItem = {
    imageLogoSmall: "Assets/Images/games/gamenet_logo_small.png",
    name: "GameNet",
    serviceId: "0"
};

function initModel() {
    var component = Qt.createComponent('../Models/GamesListModel.qml');

    if (component.status != 1) {
        console.log('FATAL: error loading model:', component.errorString());
        return null;
    }

    var list = component.createObject(null);
    if (!list) {
        console.log('FATAL: error creating model');
        return null;
    }

    var i, item;
    count = list.count;
    for (i = 0; i < count; ++i) {
        item = list.get(i);
        indexToGameItem[i] = item;
        gameIdToGameItem[item.gameId] = item;
        serviceIdToGameItemIdex[item.serviceId] = i;
    }

    return list;
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
    if (serviceId == 0) {
        return gamenetGameItem;
    }

    var index = indexByServiceId(serviceId)
    return index != undefined ? indexToGameItem[index] : undefined;
}

function indexByServiceId(serviceId) {
    return serviceIdToGameItemIdex[serviceId];
}

/**
 * Application specific functions
 */

function browseDirectory(serviceId, name, defaultDir) {
    console.log("!!! IMPLEMENT ME: App.js::browseDirectory(" + serviceId + ", " + name + ", " + defaultDir+ ")");
}

function openEditNicknameDialog() {
    console.log("!!! IMPLEMENT ME: App.js::openEditNicknameDialog()");
}

function replenishAccount() {
    console.log("!!! IMPLEMENT ME: App.js::replenishAccount()");
}

function purchasePremium(money) {
    console.log("!!! IMPLEMENT ME: App.js::purchasePremium(" + money + ")");
}

function openPremiumDetails() {
    console.log("!!! IMPLEMENT ME: App.js::openPremiumDetails()");
}

function installService(serviceId, installParams) {
    console.log("!!! IMPLEMENT ME: App.js::installService(" + serviceId + ", " + JSON.stringify(installParams) + ")");
}

function isServiceInstalled(serviceId) {
    return isSettingsEnabled("GameDownloader/" + serviceId + "/", "isInstalled", false);
}

function installDate() {
    return settingsValue('qGNA', 'installDate', 0);
}

function setInstallDate() {
    setSettingsValue('qGNA', 'installDate', Math.floor((+ new Date()) / 1000));
}

function gameInstallDate(serviceId) {
    return settingsValue("GameDownloader/" + serviceId + "/", "installDate", "");
}

function gameLastExecutionTime(serviceId) {
    return settingsValue("gameExecutor/serviceInfo/" + serviceId + "/", "lastExecutionTime", "");
}

var runningService = {},
    runningSecondService = {},
    isClientLoaded = false;

function isAnySecondServiceRunning() {
    return _signalBusInst.isAnySecondServiceRunning;
}

function secondServiceStarted(service) {
    runningSecondService[service] = 1;
    _signalBusInst.isAnySecondServiceRunning = true;
}

function secondServiceFinished(service) {
    delete runningSecondService[service];
    _signalBusInst.isAnySecondServiceRunning = Object.keys(runningSecondService) > 0;
}

