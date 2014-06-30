var _signalBusInstance = createObject('./SignalBus.qml');

function createObject(path) {
    var component = Qt.createComponent(path);
    if (component.status != 1) {
        throw new Error('Can\'t create component ' + path + ', reason: ' + component.errorString());
    }

    return component.createObject(null);
}

/**
 * Signal bus export
 */
function signalBus() {
    return _signalBusInstance;
}

function authDone(userId, appKey, cookie) {
    _signalBusInstance.authDone(userId, appKey, cookie);
}


//@deprecated
function needAuth() {
    _signalBusInstance.needAuth();
}

function setGlobalState(stateName) {
    _signalBusInstance.setGlobalState(stateName);
}

function updateFinished() {
    _signalBusInstance.updateFinished();
}

function backgroundMousePressed(mouseX, mouseY) {
    _signalBusInstance.backgroundMousePressed(mouseX, mouseY);
}

function backgroundMousePositionChanged(mouseX, mouseY) {
    _signalBusInstance.backgroundMousePositionChanged(mouseX, mouseY);
}

function updateProgress(gameItem) {
    _signalBusInstance.progressChanged(gameItem);
}

function serviceInstalled(gameItem) {
    _signalBusInstance.serviceInstalled(gameItem);
}

function serviceStarted(gameItem) {
    _signalBusInstance.serviceStarted(gameItem);
}

function serviceFinished(gameItem) {
    _signalBusInstance.serviceFinished(gameItem);
}

function downloaderStarted(gameItem) {
    _signalBusInstance.downloaderStarted(gameItem);
}

function navigate(link, from) {
     _signalBusInstance.navigate(link, from);
}

function publicTestIconClicked() {
    _signalBusInstance.publicTestIconClicked();
}

function premiumExpired() {
    _signalBusInstance.premiumExpired();
}

function prolongPremium() {
    _signalBusInstance.prolongPremium();
}

function balanceChanged(amount) {
     _signalBusInstance.balanceChanged(amount);
}

function logoutRequest() {
     _signalBusInstance.logoutRequest();
}

function logoutDone() {
    _signalBusInstance.logoutDone();
}

function setGlobalProgressVisible(value, timeout) {
    _signalBusInstance.setGlobalProgressVisible(value, timeout);
}

function gameMaintenanceStart(serviceId) {
   _signalBusInstance.gameMaintenanceStart(serviceId);
}

function gameMaintenanceEnd(serviceId) {
   _signalBusInstance.gameMaintenanceEnd(serviceId);
}

function showPurchaseOptions(itemOptions) {
    _signalBusInstance.openPurchaseOptions(itemOptions);
}

function openBuyGamenetPremiumPage() {
    _signalBusInstance.openBuyGamenetPremiumPage();
}

function hideMainWindow() {
    _signalBusInstance.hideMainWindow();
}
