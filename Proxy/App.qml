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
import "AppProxy.js" as AppProxy

QtObject {

    function isWindowVisible() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.isWindowVisible();
    }

    function anyLicenseAccepted() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.anyLicenseAccepted();
    }

    function acceptFirstLicense(serviceId) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.acceptFirstLicense(serviceId);
    }

    function getExpectedInstallPath(serviceId) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.getExpectedInstallPath(serviceId);
    }

    function fileVersion() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.fileVersion;
    }

    function hide() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.hide();
    }

    function startingService() {
        if (!AppProxy.mainWindow) {
            return false;
        }

        return mainWindow.startingService();
    }

    function openExternalUrlWithAuth(url) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.openExternalUrlWithAuth(url);
    }

    function openExternalUrl(url) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.openExternalUrl(url);
    }

    function logout() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.logout();
    }

    function authSuccessSlot(userId, appKey, cookie) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.authSuccessSlot(userId, appKey, cookie);
    }

    function downloadButtonStart(serviceId) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.downloadButtonStart(serviceId);
    }

    function downloadButtonPause(serviceId) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.downloadButtonPause(serviceId);
    }

    function executeService(serviceId) {
        if (!AppProxy.mainWindow) {
            return false;
        }

        return mainWindow.executeService(serviceId);
    }

    function language() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.language;
    }

    function saveLanguage(lang) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.saveLanguage(lang);
    }

    function selectLanguage(lang) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.selectLanguage(lang);
    }

    function activateWindow() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.activateWindow();
    }

    function setServiceInstallPath(serviceId, path, isCreateShortcut) {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.setServiceInstallPath(serviceId, path, isCreateShortcut)
    }

    function initFinished() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.initFinished();
    }

    function updateFinishedSlot() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        mainWindow.updateFinishedSlot();
    }

    function isPublicVersion() {
        if (!AppProxy.mainWindow) {
            return false;
        }
        return mainWindow.updateArea === 'live';
    }
}
