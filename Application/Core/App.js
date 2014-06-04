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
var clientWidth = 930,
    clientHeight = 550;

/**
 * Import modules
 */
Qt.include('./Modules/SignalBus.js');
Qt.include('./Modules/Host.js');

/**
 * Application specific functions
 */
function activateGame(serviceId) {
    console.log("!!! IMPLEMENT ME: App.js::activateGame()");
}

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

function updateProgress(progress, status) {
    console.log("!!! IMPLEMENT ME: App.js::updateProgress(progress, status)");
}

function installService(serviceId, installParams) {
    console.log("!!! IMPLEMENT ME: App.js::installService(" + serviceId + ", " + JSON.stringify(installParams) + ")");
}
