pragma Singleton

import QtQuick 2.4

import Application.Models 1.0
import Application.Core.Settings 1.0

import 'Modules/Mocks'
import "./App.js" as Js

Item {
    id: root

    property bool authAccepted: false
    property int count: 0 //unused

    property variant rootWindow

    property int clientWidth: 1000
    property int clientHeight: 600

    MainWindowMock {
        id: mainWindowMock
    }

    ApplicationSettingsMock {
        id: settingsViewModelInstanceMock
    }

    GameSettingsMock {
        id: gameSettingsModelMock
    }

    Item { // UNDONE
        id: messageBoxMock
    }

    QtObject {
        id: d

        property bool overlayEnabled: false
        property bool overlayChatVisible: false
    }

    function mainWindowInstance() {
        try {
            return mainWindow;
        } catch(e) {
            return mainWindowMock;
        }
    }

    function settingsViewModelInstance() {
        try {
            return settingsViewModel;
        } catch(e) {
            return settingsViewModelInstanceMock;
        }
    }

    function gameSettingsModelInstance() {
        try {
            return gameSettingsModel;
        } catch(e) {
            return gameSettingsModelMock;
        }
    }

    function messageBoxInstance() {
        try {
            return messageBox;
        } catch(e) {
            return messageBoxMock;
        }
    }

    function serviceItemByIndex(index) {
        return Js.indexToGameItem[index];
    }

    function serviceItemByGameId(gameId) {
        return Js.gameIdToGameItem[gameId];
    }

    function indexByServiceId(serviceId) {
        return Js.serviceIdToGameItemIdex[serviceId];
    }

    function serviceItemByServiceId(serviceId) {
        var index = indexByServiceId(serviceId)
        return index != undefined ? Js.indexToGameItem[index] : undefined;
    }

    function serviceExists(serviceId) {
        return Js.serviceIdToGameItemIdex.hasOwnProperty(serviceId);
    }

    function getRegisteredServices() {
        return Object.keys(Js.serviceIdToGameItemIdex);
    }

    function startingService() {
        var serviceId = startingServiceUnsafe();
        return serviceExists(serviceId) ? serviceId : "0";
    }

    function gameExists(gameId) {
        return Js.gameIdToGameItem.hasOwnProperty(gameId);
    }

    function browseDirectory(serviceId, name, defaultDir) { // unused
        return gameSettingsModelInstance().browseDirectory(serviceId, name, defaultDir);
    }

    function isWindowVisible() {
        return mainWindowInstance().isWindowVisible();
    }

    function isAnyLicenseAccepted() {
        return mainWindowInstance().anyLicenseAccepted();
    }

    function acceptFirstLicense(serviceId) {
        mainWindowInstance().acceptFirstLicense(serviceId);
    }

    function getExpectedInstallPath(serviceId) {
        return mainWindowInstance().getExpectedInstallPath(serviceId);
    }

    function fileVersion() {
        return mainWindowInstance().fileVersion;
    }

    function hide() {
        mainWindowInstance().hide();
    }

    function startingServiceUnsafe() {
        return mainWindowInstance().startingService();
    }

    function openExternalUrlWithAuth(url) {
        mainWindowInstance().openExternalUrlWithAuth(url);
    }

    function openProfile(userId, action) {
        var uri = "https://gamenet.ru/users/" + userId + "/";
        if (action) {
            uri += '?action=' + action;
        }
        openExternalUrlWithAuth(uri);
    }

    function openExternalUrl(url) {
        mainWindowInstance().openExternalUrl(url);
    }

    function logout() {
        mainWindowInstance().logout();
    }

    function authSuccessSlot(userId, appKey, cookie) {
        mainWindowInstance().authSuccessSlot(userId, appKey, cookie);
    }

    function downloadButtonStart(serviceId) {
        mainWindowInstance().downloadButtonStart(serviceId);
    }

    function downloadButtonPause(serviceId) {
        mainWindowInstance().downloadButtonPause(serviceId);
    }

    function executeService(serviceId) {
        return mainWindowInstance().executeService(serviceId);
    }

    function isCapsLockEnabled() {
        try {
            return keyboardHook.capsLockEnabled;
        } catch(e) {
            return true;
        }
    }

    function keyboardLayout() {
        try {
            return keyboardHook.keyboardLayout;
        } catch(e) {
            return "RU";
        }
    }

    function language() {
        return mainWindowInstance().language;
    }

    function saveLanguage(lang) {
        return mainWindowInstance().saveLanguage(lang);
    }

    function selectLanguage(lang) { // unused
        return mainWindowInstance().selectLanguage(lang);
    }

    function activateWindow() {
        mainWindowInstance().activateWindow();
    }

    function setServiceInstallPath(serviceId, path) {
        mainWindowInstance().setServiceInstallPath(serviceId, path)
    }

    function initFinished() {
        mainWindowInstance().initFinished();
    }

    function updateFinishedSlot() { // unused прямое исопльзование в try-модели
        mainWindowInstance().updateFinishedSlot();
    }

    function isPublicVersion() {
        return settingsViewModelInstance().updateArea === 'live';
    }

    function isPublicTestVersion() {
        return settingsViewModelInstance().updateArea === 'pts';
    }

    function isPrivateTestVersion() {
        return settingsViewModelInstance().updateArea === 'tst';
    }

    function switchClientVersion() {
        mainWindowInstance().switchClientVersion();
    }

    function updateProgressEx(value, status) {
        mainWindowInstance().onProgressUpdated(value, status);
    }

    function windowPosition() { // unused
        return mainWindowInstance().pos;
    }

    function isSilentMode() {
        return mainWindowInstance().silent();
    }

    function executeSecondService(serviceId, userId, appKey) {
        mainWindowInstance().executeSecondService(serviceId, userId, appKey);
    }

    function terminateSecondService() {
        mainWindowInstance().terminateSecondService();
    }

    function restartApplication(sameArgs) {
        mainWindowInstance().restartApplication(sameArgs || false);
    }

    function setTaskbarIcon(source) {
        mainWindowInstance().setTaskbarIcon(source);
    }

    function uninstallService(serviceId) {
        mainWindowInstance().uninstallService(serviceId);
    }

    function cancelServiceUninstall(serviceId) {
        mainWindowInstance().cancelServiceUninstall(serviceId);
    }

    function isQmlViewer() {
        try {
            return !mainWindow;
        } catch(e) {
            return true
        }
    }

    function fillGamesModel(data) {
        var i,
                item,
                last,
                isGameNetItem,
                isItemShouldBeShown;

        root.count = data.length;

        Games.clear();

        for (i = 0; i < root.count; ++i) {
            item = Js.createService(data[i]);

            if (!item) {
                continue;
            }

            isGameNetItem = (item.serviceId == '0');
            isItemShouldBeShown = isPrivateTestVersion() || item.isPublishedInApp || isGameNetItem;

            if (!isItemShouldBeShown) {
                continue;
            }

            Games.fillMenu(item);
            Games.append(item);

            last = Games.count - 1;
            Js.indexToGameItem[i] = Games.get(last);
            Js.gameIdToGameItem[item.gameId] = Games.get(last);
            Js.serviceIdToGameItemIdex[item.serviceId] = i;
        }
    }

    function currentRunningMainService() {
        var serviceItem;
        for (var i = 0; i < Games.count; i++) {
            serviceItem = Games.get(i);

            if (serviceItem.status === "Started" || serviceItem.status === "Starting") {
                return serviceItem.serviceId;
            }
        }
    }

    function currentRunningSecondService() {
        var serviceItem;
        for (var i = 0; i < Games.count; i++) {
            serviceItem = Games.get(i);

            if (serviceItem.secondStatus === "Started" || serviceItem.secondStatus === "Starting") {
                return serviceItem.serviceId;
            }
        }
    }

    function isAnyServiceLocked() {
        var serviceItem;
        for (var i = 0; i < Games.count; i++) {
            serviceItem = Games.get(i);

            if (serviceItem.locked) {
                return true;
            }
        }

        return false;
    }

    function activateGame(item) {
        Js._previousGame = Games.currentGameItem;
        Games.currentGameItem = item;
    }

    function previousGame(item) {
        return Js._previousGame;
    }

    function activateGameByServiceId(serviceId) {
        var item = serviceItemByServiceId(serviceId);

        if (!item)
            return;

        activateGame(item);
    }

    function currentGame() {
        return Games.currentGameItem;
    }

    function replenishAccount() {
        openExternalUrlWithAuth("https://gamenet.ru/money/");
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

        if (item.status === "Uninstalling") {
            return false;
        }

        return true;
    }

    function setOverlayEnabled(value) {
        d.overlayEnabled = value;
    }

    function isOverlayEnabled() {
        return d.overlayEnabled;
    }

    function setOverlayChatVisible(isVisible) {
        d.overlayChatVisible = isVisible;
    }

    function overlayChatVisible() {
        return d.overlayChatVisible;
    }

    function setServiceGrid(value) {
        Js.servicesGrid = value;
    }

    function serviceGrid() {
        return Js.servicesGrid;
    }

    function getRunningServices() {
        return Js.runningService;
    }

    function serviceStarted(serviceId) {
        Js.runningService[serviceId] = 1;
    }

    function serviceStopped(serviceId) {
        delete Js.runningService[serviceId];
    }

    function isServiceRunning(serviceId) {
        return !!Js.runningService[serviceId];
    }
}
