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

QtObject {
    function isWindowVisible() {
        return mainWindow.isWindowVisible();
    }

    function anyLicenseAccepted() {
        return mainWindow.anyLicenseAccepted();
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

    function openExternalBrowser(url) {
        mainWindow.openExternalBrowser(url);
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
}
