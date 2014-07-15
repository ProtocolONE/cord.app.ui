/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import qGNA.Library 1.0

QtObject {
    function browseDirectory(serviceId, name, defaultDir) {
        return gameSettingsModel.browseDirectory(serviceId, name, defaultDir);
    }

    function isWindowVisible() {
        return mainWindow.isWindowVisible();
    }

    function anyLicenseAccepted() {
        return mainWindow.anyLicenseAccepted();
    }

    function acceptFirstLicense(serviceId) {
        mainWindow.acceptFirstLicense(serviceId);
    }

    function getExpectedInstallPath(serviceId) {
        return mainWindow.getExpectedInstallPath(serviceId);
    }

    function fileVersion() {
        return mainWindow.fileVersion;
    }

    function hide() {
        mainWindow.hide();
    }

    function startingService() {
        return mainWindow.startingService();
    }

    function openExternalUrlWithAuth(url) {
        mainWindow.openExternalUrlWithAuth(url);
    }

    function openExternalUrl(url) {
        mainWindow.openExternalUrl(url);
    }

    function logout() {
        mainWindow.logout();
    }

    function authSuccessSlot(userId, appKey, cookie) {
        mainWindow.authSuccessSlot(userId, appKey, cookie);
    }

    function downloadButtonStart(serviceId) {
        mainWindow.downloadButtonStart(serviceId);
    }

    function downloadButtonPause(serviceId) {
        mainWindow.downloadButtonPause(serviceId);
    }

    function executeService(serviceId) {
        return mainWindow.executeService(serviceId);
    }

    function isCapsLockEnabled() {
        return keyboardHook.capsLockEnabled;
    }

    function keyboardLayout() {
        return keyboardHook.keyboardLayout;
    }

    function language() {
        return mainWindow.language;
    }

    function saveLanguage(lang) {
        return mainWindow.saveLanguage(lang);
    }

    function selectLanguage(lang) {
        return mainWindow.selectLanguage(lang);
    }

    function activateWindow() {
        mainWindow.activateWindow();
    }

    function setServiceInstallPath(serviceId, path, isCreateShortcut) {
        mainWindow.setServiceInstallPath(serviceId, path, isCreateShortcut)
    }

    function initFinished() {
        mainWindow.initFinished();
    }

    function updateFinishedSlot() {
        mainWindow.updateFinishedSlot();
    }

    function isPublicVersion() {
        return mainWindow.updateArea === 'live';
    }

    function isPublicTestVersion() {
        return mainWindow.updateArea === 'pts';
    }

    function switchClientVersion() {
        settingsViewModel.switchClientVersion();
    }

    function updateProgress(value, status) {
        mainWindow.onProgressUpdated(value, status);
    }

    function windowPosition() {
        return mainWindow.pos;
    }

    function isSilentMode() {
        return mainWindow.silent();
    }

    function executeSecondService(serviceId, userId, appKey) {
        mainWindow.executeSecondService(serviceId, userId, appKey);
    }

    function terminateSecondService() {
        mainWindow.terminateSecondService();
    }

    function restartApplication(sameArgs) {
        mainWindow.restartApplication(sameArgs || false);
    }
}
