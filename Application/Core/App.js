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

var _signalBusComponent,
    _signalBusInstance;

if (!_signalBusComponent) {
    _signalBusComponent = Qt.createComponent('./App.qml');
    if (_signalBusComponent.status == 1) {
        _signalBusInstance = _signalBusComponent.createObject(null);
    } else {
        console.log('Can\'t create component Core/App.qml');
    }
}

function signalBus() {
    return _signalBusInstance;
}

function authDone(userId, appKey, cookie) {
    _signalBusInstance.authDone(userId, appKey, cookie);
}

function openExternalUrl(url) {
    console.log("!!! IMPLEMENT ME: App.js::openExternalUrl(" + url + ")");
}

function getExpectedInstallPath(serviceId) {
    console.log("!!! IMPLEMENT ME: App.js::getExpectedInstallPath(" + serviceId + ")");
    return "C:\\Games\\" + serviceId;
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

function isWindowVisible() {
    console.log("!!! IMPLEMENT ME: App.js::isWindowVisible()");
    return true;
}

function installService(serviceId, installParams) {
    console.log("!!! IMPLEMENT ME: App.js::installService(" + serviceId + ", " + JSON.stringify(installParams) + ")");
}