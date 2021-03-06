pragma Singleton

import QtQuick 2.4
import Application.Core.Settings 1.0

Item {

    function installDate() {
        if (wrapper.item) {
            return wrapper.item.installDate();
        }

        return AppSettings.value('Launcher', 'installDate', 0);
    }

    function installWithService() {
        if (wrapper.item) {
            return wrapper.item.installWithService();
        }

        return AppSettings.value('Launcher', 'installWithService', "0");
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
