pragma Singleton

import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0

import Application.Models 1.0
import Application.Core.Settings 1.0
import Application.Core.Config 1.0

import 'Modules/Mocks'
import "./App.js" as Js
Item {
    id: root

    property bool authAccepted: false

    property variant rootWindow

    property int clientWidth: 1000
    property int clientHeight: 600 +30

    signal openAuthUrlRequest(string url)

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
        property bool isSingleGameMode: false
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

    function getBestInstallPath(serviceId) {
       return mainWindowInstance().getBestInstallPath(serviceId);
    }

    function fileVersion() {
        return mainWindowInstance().fileVersion;
    }

    function hideToTaskBar() {
        mainWindowInstance().hideToTaskBar();
    }

    function hide() {
        mainWindowInstance().hide();
    }

    function startingServiceUnsafe() {
        return mainWindowInstance().startingService();
    }

    function openExternalUrlWithAuth(url) {
        root.openAuthUrlRequest(url)
    }

    function openProfile(userId, action) {
//        var uri = ConfigJs.GnUrl.site("/users/") + userId + "/";
//        if (action) {
//            uri += '?action=' + action;
//        }

//        openExternalUrlWithAuth(uri);
    }

    function openExternalUrl(url) {
        mainWindowInstance().openExternalUrl(url);
    }

    function logout() {
        mainWindowInstance().logout();
    }

    function authSuccessSlot(accessToken, acccessTokenExpiredTime) {
        mainWindowInstance().authSuccessSlot(accessToken, acccessTokenExpiredTime);
    }

    function updateAuthCredential(
              accessTokenOld, acccessTokenExpiredTimeOld
            , accessTokenNew, acccessTokenExpiredTimeNew)
    {
        mainWindowInstance().updateAuthCredential(
                    accessTokenOld, acccessTokenExpiredTimeOld
                  , accessTokenNew, acccessTokenExpiredTimeNew);
    }

    function downloadButtonStart(serviceId) {
        mainWindowInstance().downloadButtonStart(serviceId);
    }

    function downloadButtonPause(serviceId) {
        mainWindowInstance().downloadButtonPause(serviceId);
    }

    function isLicenseAccepted(serviceId) {
        return mainWindowInstance().isLicenseAccepted(serviceId);
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

    function updateKeyboardLayout() {
        try {
            return keyboardHook.update();
        } catch(e) {
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

    function updateArea() {
        return settingsViewModelInstance().updateArea;
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

    function terminateGame(serviceId) {
        mainWindowInstance().terminateGame(serviceId);
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
                isItemShouldBeShown;

        Games.clear();

        for (i = 0; i < data.length; ++i) {
            item = Js.createService(data[i], Config.site());

            if (!item) {
                continue;
            }

            isItemShouldBeShown = isPrivateTestVersion() || item.isPublishedInApp;

            if (!isItemShouldBeShown) {
                continue;
            }

            var sellItems = data[i].sellsStandaloneItems;
            if (!(sellItems instanceof Array)) {
                sellItems = [];
            }

            sellItems = Lodash._.filter(sellItems, "isActive", true);
            Js.sellItems[item.serviceId] = sellItems;

            item.hasSellsItem = sellItems.length > 0;
            item.cost = gameCost(item.serviceId);

            Games.fillMenu(item);
            Games.append(item);

            last = Games.count - 1;
            Js.indexToGameItem[i] = Games.get(last);
            Js.gameIdToGameItem[item.gameId] = Games.get(last);
            Js.serviceIdToGameItemIdex[item.serviceId] = i;
        }
    }

    function gameCost(serviceId) {
        var sellItems = sellItemByServiceId(serviceId);
        var sellItem = Lodash._.find(sellItems, 'isActive');
        if (sellItem) {
            return sellItem.cost;
        }

        return 0;
    }

    function findServiceByStatus(status, checkSecond) {
        var serviceItem,
            prop = checkSecond ? 'secondStatus' : 'status';

        for (var i = 0; i < Games.count; i++) {
            serviceItem = Games.get(i);
            if (status.indexOf(serviceItem[prop]) !== -1) {
                return serviceItem.serviceId;
            }
        }
        return null;
    }

    function currentRunningMainService() {
        return findServiceByStatus(["Started", "Starting"]);
    }

    function currentRunningSecondService() {
        return findServiceByStatus(["Started", "Starting"], true);
    }

    function getServicesWithExtendedAccountedSupport() {
        var ret = [],
            serviceItem;

        for (var i = 0; i < Games.count; i++) {
            serviceItem = Games.get(i);
            if (serviceItem.secondAllowed) {
                ret.push(serviceItem);
            }
        }
        return ret;
    }

    function isAnyServiceStarted() {
        return currentRunningMainService()
            || currentRunningSecondService();
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

    function resetGame() {
        activateGame(null)
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
        //openExternalUrlWithAuth(ConfigJs.GnUrl.site("/pay/"));
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

    function openSupportUrl(returnPath) {
        //id=10 это хардкоженная переменная, которую можно получить только после
        //установки плагина авторизации ProtocolOne в DeskPro.

//        var uri = ConfigJs.GnUrl.login('/integrations/deskpro/?id=10');
//        if (returnPath) {
//            uri += '&return=' + encodeURIComponent(returnPath);
//        }

//        openExternalUrlWithAuth(uri);
    }

    function sellItemByServiceId(serviceId) {
        if (!Js.sellItems.hasOwnProperty(serviceId)) {
            return [];
        }

        return Js.sellItems[serviceId];
    }

    function isSingleGameMode() {
        return d.isSingleGameMode
    }

    function setSingleGameMode(value) {
        d.isSingleGameMode = value;
    }

    function activateFirstGame() {
        activateGame(Js.indexToGameItem[0])
    }
}
