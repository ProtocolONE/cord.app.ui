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

function startingService() {
    if (proxyInst) {
        return proxyInst.startingService();
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
        return proxyInst.updateProgress(value, status);
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
        proxyInst.browseDirectory(serviceId, name, defaultDir);
    }
}
