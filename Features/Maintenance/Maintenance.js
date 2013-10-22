.pragma library

var tmp = Qt.include('./../../Proxy/Settings.js');

var schedule = {},
    updatedService = {},
    showMaintenanceEnd = {};

function isShowEndPopup() {
    return isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true);
}

function setShowEndPopup(value) {
    setAppSettingsValue('notifications', 'maintenanceEndPopup', value);
}
