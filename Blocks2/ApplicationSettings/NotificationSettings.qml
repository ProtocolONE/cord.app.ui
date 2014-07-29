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
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../../GameNet/Components/Widgets/WidgetManager.js" as WidgetManager
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    function save() {
        App.setAppSettingsValue('notifications', 'maintenanceEndPopup', notificationEnabled.checked);

        var settings = WidgetManager.getWidgetSettings('Messenger');
        settings.messengerReceivedMessage = receivedMsgEnabled.checked;
        settings.save();
    }

    function load() {
        var settings = WidgetManager.getWidgetSettings('Messenger');
        receivedMsgEnabled.checked = settings.messengerReceivedMessage; //copy of value, use Binding for 2 way bind

        notificationEnabled.checked = App.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true);
    }

    function gaEvent(name) {
        var gameItem = App.currentGame();

        if (!gameItem) {
            return;
        }

        GoogleAnalytics.trackEvent('/announcement/gameMaintenanceEndShow/' + gameItem.serviceId,
                                   'Announcement', name, gameItem.gaName);
    }

    Column {
        x: 30
        spacing: 20

        CheckBox {
            id: notificationEnabled

            text: qsTr("CHECKBOX_NOTIFICATION_MAINTENANCE_END")
            checked: App.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true);
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            onToggled: {
                if (checked) {
                    root.gaEvent("ChangeSettings", 1);
                } else {
                    root.gaEvent("ChangeSettings", 0);
                }
            }
        }

        CheckBox {
            id: receivedMsgEnabled

            text: qsTr("CHECKBOX_NOTIFICATION_MESSANGER_RECEIVED_MESSAGE")
            checked: App.isAppSettingsEnabled('notifications', 'messengerReceivedMessage', true);
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
        }
    }
}
