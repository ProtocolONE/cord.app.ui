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
