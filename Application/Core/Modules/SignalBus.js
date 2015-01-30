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

function secondAuthDone(userId, appKey, cookie) {
    _signalBusInstance.secondAuthDone(userId, appKey, cookie);
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

function serviceUpdated(gameItem) {
    _signalBusInstance.serviceUpdated(gameItem);
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

function balanceChanged(amount) {
     _signalBusInstance.balanceChanged(amount);
}

function logoutRequest() {
     _signalBusInstance.logoutRequest();
}

function logoutDone() {
    _signalBusInstance.logoutDone();
}

function logoutSecondRequest() {
     _signalBusInstance.logoutSecondRequest();
}

function setGlobalProgressVisible(value, timeout) {
    _signalBusInstance.setGlobalProgressVisible(value, timeout);
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

function exitApplication() {
     _signalBusInstance.exitApplication();
}

function leftMousePress(root, x, y) {
    _signalBusInstance.leftMousePress(root, x, y);
}

function leftMouseRelease(root, x, y) {
    _signalBusInstance.leftMouseRelease(root, x, y);
}

function needPakkanenVerification() {
    _signalBusInstance.needPakkanenVerification();
}

function selectService(serviceId) {
    _signalBusInstance.selectService(serviceId);
}

function settingsChange(path, key, value) {
    _signalBusInstance.settingsChange(path, key, value);
}

function setTrayIcon(source) {
    _signalBusInstance.setTrayIcon(source);
}

function setAnimatedTrayIcon(animatedSource) {
    _signalBusInstance.setAnimatedTrayIcon(animatedSource);
}

function updateTaskbarIcon(source) {
    _signalBusInstance.updateTaskbarIcon(source);
}

function unreadContactsChanged(contacts) {
    _signalBusInstance.unreadContactsChanged(contacts);
}

function uninstallRequested(serviceId) {
    _signalBusInstance.uninstallRequested(serviceId);
}

function uninstallStarted(serviceId) {
    _signalBusInstance.uninstallStarted(serviceId);
}

function uninstallProgressChanged(serviceId, progress) {
    _signalBusInstance.uninstallProgressChanged(serviceId, progress);
}

function uninstallFinished(serviceId) {
    _signalBusInstance.uninstallFinished(serviceId);
}

function openDetailedUserInfo(opt) {
    _signalBusInstance.openDetailedUserInfo(opt);
}

function closeDetailedUserInfo() {
    _signalBusInstance.closeDetailedUserInfo();
}

function servicesLoaded() {
    _signalBusInstance.servicesLoaded();
}
