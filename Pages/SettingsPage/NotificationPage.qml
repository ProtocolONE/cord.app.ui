/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (В©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1

import "../../Elements" as Elements
import "../../js/Core.js" as Core
import "../../Proxy/App.js" as App
import "../../Features/Maintenance/Maintenance.js" as Maintenance
import "../../js/GoogleAnalytics.js" as GoogleAnalytics


Column {
    spacing: 10
    anchors.fill: parent

    Elements.CheckBox {
        function gaEvent(name) {
            var gameItem = Core.currentGame();
            GoogleAnalytics.trackEvent('/announcement/gameMaintenanceEndShow/' + gameItem.serviceId,
                                       'Announcement', name, gameItem.gaName);
        }

        state: Maintenance.isShowEndPopup() ? "Active" : "Normal"
        buttonText: qsTr("CHECKBOX_NOTIFICATION_MAINTENANCE_END")
        onChecked: {
            Maintenance.setShowEndPopup(true);
            gaEvent("ChangeSettings", 1);
        }

        onUnchecked: {
            Maintenance.setShowEndPopup(false);
            gaEvent("ChangeSettings", 0);
        }
    }
}


