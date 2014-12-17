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

var proxyInst = createObject('./Host.qml');

function createObject(path) {
    var component = Qt.createComponent(path);
    if (component.status != 1) {
        throw new Error('Can\'t create component ' + path + ', reason: ' + component.errorString());
    }

    return component.createObject(null);
}

function isWindowVisible() {
    if (proxyInst) {
        return proxyInst.isWindowVisible();
    }

    return true;
}

function isAnyLicenseAccepted() {
    if (proxyInst) {
        return proxyInst.anyLicenseAccepted();
    }

    return true;
}

function isLicenseAccepted(serviceId) {
    if (proxyInst) {
        return proxyInst.isLicenseAccepted(serviceId);
    }

    return true;
}

function acceptFirstLicense(serviceId) {
    if (proxyInst) {
        proxyInst.acceptFirstLicense(serviceId);
    }
}

function getExpectedInstallPath(serviceId) {
    if (proxyInst) {
        return proxyInst.getExpectedInstallPath(serviceId);
    }

    return 'App proxy can`t return `getExpectedInstallPath` result';
}

function fileVersion() {
    if (proxyInst) {
        return proxyInst.fileVersion();
    }

    return '0.0.0.0';
}

function hide() {
    if (proxyInst) {
        return proxyInst.hide();
    }
}

function startingServiceUnsafe() {
    if (proxyInst) {
        return proxyInst.startingServiceUnsafe();
    }

    return '0';
}

function openExternalUrlWithAuth(url) {
    if (proxyInst) {
        return proxyInst.openExternalUrlWithAuth(url);
    }

    Qt.openUrlExternally(url);
}

function openExternalUrl(url) {
    if (proxyInst) {
        return proxyInst.openExternalUrl(url);
    }

    Qt.openUrlExternally(url)
}

function openProfile(userId) {
    openExternalUrlWithAuth("https://gamenet.ru/users/" + userId);
}

function logout() {
    if (proxyInst) {
        return proxyInst.logout();
    }
}

function authSuccessSlot(userId, appKey, cookie) {
    if (proxyInst) {
        return proxyInst.authSuccessSlot(userId, appKey, cookie);
    }
}

function downloadButtonStart(serviceId) {
    if (proxyInst) {
        return proxyInst.downloadButtonStart(serviceId);
    }
}

function isPublicVersion() {
    if (proxyInst) {
        return proxyInst.isPublicVersion();
    }
    return false;
}

function updateProgress(value, status) {
    if (proxyInst) {
        return proxyInst.executeService(serviceId);
    }
    return false;
}

function isCapsLockEnabled() {
    if (proxyInst) {
        return proxyInst.isCapsLockEnabled();
    }

    return true;
}

function language() {
    if (proxyInst) {
        return proxyInst.isSilentMode();
    }

    return 'ru';
}

function saveLanguage(lang) {
    if (proxyInst) {
        proxyInst.saveLanguage(lang);
    }
}

function selectLanguage(lang) {
    if (proxyInst) {
        proxyInst.selectLanguage(lang);
    }
}

function activateWindow() {
    if (proxyInst) {
        proxyInst.activateWindow();
    }
}

function setServiceInstallPath(serviceId, path) {
    if (proxyInst) {
        proxyInst.setServiceInstallPath(serviceId, path);
    }
}

function initFinished() {
    if (proxyInst) {
        proxyInst.initFinished();
    }
}

function updateFinishedSlot() {
    if (proxyInst) {
        proxyInst.updateFinishedSlot();
    }
}

function isPublicVersion() {
    if (proxyInst) {
        return proxyInst.isPublicVersion();
    }
    return false;
}

function isPublicTestVersion() {
    if (proxyInst) {
        return proxyInst.isPublicTestVersion();
    }
    return true;
}

function isPrivateTestVersion() {
    if (proxyInst) {
        return proxyInst.isPrivateTestVersion();
    }
    return false;
}

function switchClientVersion() {
    if (proxyInst) {
        return proxyInst.switchClientVersion();
    }
}

function windowPosition() {
    if (proxyInst) {
        return proxyInst.windowPosition();
    }

    return null;
}

function keyboardLayout() {
    if (proxyInst) {
        return proxyInst.keyboardLayout();
    }

    return "RU";
}

function updateProgressEx(value, status) {
    if (proxyInst) {
        proxyInst.updateProgressEx(value, status);
    }
}

function browseDirectory(serviceId, name, defaultDir) {
    if (proxyInst) {
        return proxyInst.browseDirectory(serviceId, name, defaultDir);
    }
}

function executeSecondService(serviceId, userId, appKey) {
    if (proxyInst) {
        proxyInst.executeSecondService(serviceId, userId, appKey);
    }
}

function terminateSecondService() {
    if (proxyInst) {
        proxyInst.terminateSecondService();
    }
}

function mainWindowInstance() {
    if (proxyInst) {
        return proxyInst.mainWindowInstance();
    }

    return null;
}

function messageBoxInstance() {
    if (proxyInst) {
        return proxyInst.messageBoxInstance();
    }

    return null;
}

function enterNickNameViewModelInstance() {
    if (proxyInst) {
        return proxyInst.enterNickNameViewModelInstance();
    }

    return null;
}

function settingsViewModelInstance() {
    if (proxyInst) {
        return proxyInst.settingsViewModelInstance();
    }

    return null;
}

function licenseModelInstance() {
    if (proxyInst) {
        return proxyInst.licenseModelInstance();
    }

    return null;
}

function gameSettingsModelInstance() {
    if (proxyInst) {
        return proxyInst.gameSettingsModelInstance();
    }

    return null;
}

function setTaskbarIcon(source) {
    if (proxyInst) {
        proxyInst.setTaskbarIcon(source);
    }
}

function getDefaultBrowser() {
    /*
    IE.AssocFile.HTM
    FirefoxHTML
    ChromeHTML
    Opera.HTML
    */
    if (proxyInst) {
        return proxyInst.getDefaultBrowser();
    }

    return null;
}
