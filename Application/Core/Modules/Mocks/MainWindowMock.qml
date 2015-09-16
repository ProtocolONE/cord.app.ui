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
    signal windowDeactivated();
    signal windowActivated();

    signal downloadButtonPause(string serviceId);
    signal downloadButtonStart(string serviceId);
    signal executeService(string serviceId);

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

    signal hide();

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
        return false;
    }

    function saveLanguage() {

    }
}
