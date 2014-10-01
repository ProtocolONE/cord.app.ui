.pragma library
var _applicationStatistic = createObject('./ApplicationStatistic.qml');

function createObject(path) {
    var component = Qt.createComponent(path);
    if (component.status != 1) {
        throw new Error('Can\'t create component ' + path + ', reason: ' + component.errorString());
    }

    return component.createObject(null);
}

function installDate() {
    if (_applicationStatistic) {
        return _applicationStatistic.installDate();
    }

    return settingsValue('qGNA', 'installDate', 0);
}

function installWithService() {
    if (_applicationStatistic) {
        return _applicationStatistic.installWithService();
    }

    return settingsValue('qGNA', 'installWithService', "0");
}

function executeGameSuccessCount(serviceId) {
    if (_applicationStatistic) {
        return  _applicationStatistic.executeGameSuccessCount(serviceId);
    }

    return +(settingsValue("gameExecutor/serviceInfo/" + serviceId + "/", "successCount", "0"));
}

function executeGameFailedCount(serviceId) {
    if (_applicationStatistic) {
        return _applicationStatistic.executeGameFailedCount(serviceId);
    }

    return +(settingsValue("gameExecutor/serviceInfo/" + serviceId + "/", "failedCount", "0"));
}

function executeGameTotalCount(serviceId) {
    if (_applicationStatistic) {
        return _applicationStatistic.executeGameTotalCount(serviceId);
    }

    return executeGameSuccessCount(serviceId) + executeGameFailedCount(serviceId);
}

function isServiceInstalled(serviceId) {
    if (_applicationStatistic) {
        return _applicationStatistic.isGameInstalled(serviceId);
    }

    return isSettingsEnabled("GameDownloader/" + serviceId + "/", "isInstalled", false);
}

function gameInstallDate(serviceId) {
    if (_applicationStatistic) {
        return _applicationStatistic.gameInstallDate(serviceId);
    }

    return settingsValue("GameDownloader/" + serviceId + "/", "installDate", "");
}

function gameLastExecutionTime(serviceId) {
    if (_applicationStatistic) {
        return _applicationStatistic.gameLastExecutionTime(serviceId);
    }

    return settingsValue("gameExecutor/serviceInfo/" + serviceId + "/", "lastExecutionTime", "");
}

