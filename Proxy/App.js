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

var proxyComponent,
    proxyInst;

if (!proxyComponent) {
    proxyComponent = Qt.createComponent('./App.qml');
    proxyInst = proxyComponent.createObject(null);
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

function openExternalBrowser(url) {
    if (proxyInst) {
        return proxyInst.openExternalBrowser(url);
    }
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
