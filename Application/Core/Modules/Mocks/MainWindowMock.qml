import QtQuick 2.4

Item {
    id: fakeMainWindowsInstance

    property string updateArea: "tst"
    property point pos: Qt.point(0, 0)
    property string fileVersion: "1.0.0.debug"
    property string language: "ru"

    signal leftMousePress(int globalX, int globalY);
    signal leftMouseRelease(int globalX, int globalY);

    signal closeMainWindow();

    signal downloadButtonPause(string serviceId);
    signal showLicense(string serviceId);

    function downloadButtonStart(serviceId) {
        console.log("downloadButtonStart", serviceId);
        downloaderStarted(serviceId, 0);
        downloaderFinished(serviceId);
    }

    function executeService(serviceId) {
        console.log("executeService", serviceId);
        serviceStarted(serviceId);

        fakeGameExitTimeout.serviceId = serviceId;
        fakeGameExitTimeout.restart();
    }

    Timer {
        id: fakeGameExitTimeout

        property string serviceId
        interval: 5000
        repeat: false
        onTriggered: {
            serviceFinished(serviceId, 0);
            fakeMainWindowsInstance.activateWindow();
        }
    }

    signal downloaderStarted(string service, int startType);
    signal downloaderFinished(string service);
    signal downloaderStopped(string service);
    signal downloaderStopping(string service);
    signal downloaderFailed(string service);
    signal downloaderServiceStatusMessageChanged(string service, string message);

    signal serviceStarted(string service);
    signal serviceFinished(string service, int serviceState);
    signal serviceInstalled(string serviceId);
    signal wrongCredential(string userId);

    signal navigate(string page);
    signal selectService(string serviceId);
    signal needPakkanenVerification();
    signal restartUIRequest();
    signal shutdownUIRequest();
    signal additionalResourcesReady();

    signal hide();
    signal windowActivated();

    signal authGuestConfirmRequest(string serviceId);

    signal onSecondServiceFinished();

    function openExternalUrl(url) {
        Qt.openUrlExternally(url);
    }

    function openExternalUrlWithAuth(url) {
        Qt.openUrlExternally(url);
    }

    function isWindowVisible() {
        return true;
    }

    function activateWindow() {
        fakeMainWindowsInstance.windowActivated();
    }

    function setServiceInstallPath(serviceId, path) {
    }

    function initFinished() {
    }

    function updateFinishedSlot() {
    }

    function switchClientVersion() {
    }

    function restartApplication(sameArgs) {
    }

    function uninstallService(serviceId) {
    }

    function cancelServiceUninstall(serviceId) {
    }

    function authSuccessSlot(userId, appKey, cookie) {
    }

    function startingService() {
    }

    function anyLicenseAccepted() {
        return true;
    }

    function logout() {
    }

    function terminateSecondService() {
    }

    function setTaskbarIcon(value) {
    }

    function onProgressUpdated(value, status) {
    }

    function silent() {
        return true;
    }

    function saveLanguage() {

    }

    function isLicenseAccepted(qwe) {
        return true;
    }

    function acceptFirstLicense(qwe) {
        console.log("accept lisence", qwe)
    }

    function getExpectedInstallPath(qwe) {
        return "D:\\Games\\BattleCarnival"
    }
}
