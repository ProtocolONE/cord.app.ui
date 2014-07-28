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
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    function save() {
        App.setAppSettingsValue('notifications', 'maintenanceEndPopup', notificationEnabled.checked);
        App.setAppSettingsValue('notifications', 'messengerReceivedMessage', receivedMsgEnabled.checked);

        //HACK Костыль. На текущий момент не вижу более верного решения уведомить всё остальное приложение об
        //изменении этой настройки. Скажите, если есть другие идеи.
        App.settingsChange('notifications', 'messengerReceivedMessage', receivedMsgEnabled.checked);
    }

    function load() {
        receivedMsgEnabled.checked = App.isAppSettingsEnabled('notifications', 'messengerReceivedMessage', true);
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
