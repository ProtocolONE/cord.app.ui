/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

pragma Singleton

import QtQuick 2.4
import Application.Core.Settings 1.0

Item {

    function installDate() {
        if (wrapper.item) {
            return wrapper.item.installDate();
        }

        return AppSettings.value('qGNA', 'installDate', 0);
    }

    function installWithService() {
        if (wrapper.item) {
            return wrapper.item.installWithService();
        }

        return AppSettings.value('qGNA', 'installWithService', "0");
    }

    function executeGameSuccessCount(serviceId) {
        if (wrapper.item) {
            return  wrapper.item.executeGameSuccessCount(serviceId);
        }

        return +(AppSettings.value("gameExecutor/serviceInfo/" + serviceId + "/", "successCount", "0"));
    }

    function executeGameFailedCount(serviceId) {
        if (wrapper.item) {
            return wrapper.item.executeGameFailedCount(serviceId);
        }

        return +(AppSettings.value("gameExecutor/serviceInfo/" + serviceId + "/", "failedCount", "0"));
    }

    function executeGameTotalCount(serviceId) {
        if (wrapper.item) {
            return wrapper.item.executeGameTotalCount(serviceId);
        }

        return executeGameSuccessCount(serviceId) + executeGameFailedCount(serviceId);
    }

    function isServiceInstalled(serviceId) {
        if (wrapper.item) {
            return wrapper.item.isGameInstalled(serviceId);
        }

        return AppSettings.isSettingsEnabled("GameDownloader/" + serviceId + "/", "isInstalled", false);
    }

    function gameInstallDate(serviceId) {
        if (wrapper.item) {
            return wrapper.item.gameInstallDate(serviceId);
        }

        return AppSettings.value("GameDownloader/" + serviceId + "/", "installDate", "");
    }

    function gameLastExecutionTime(serviceId) {
        if (wrapper.item) {
            return wrapper.item.gameLastExecutionTime(serviceId);
        }

        return AppSettings.value("gameExecutor/serviceInfo/" + serviceId + "/", "lastExecutionTime", "");
    }

    Loader {
        id: wrapper

        source: "./ApplicationStatisticPrivate.qml"
    }
}
