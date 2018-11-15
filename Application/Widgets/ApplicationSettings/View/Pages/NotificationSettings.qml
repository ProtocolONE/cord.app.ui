import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Settings 1.0

Item {
    id: root

    function save() {
        AppSettings.setAppSettingsValue('notifications', 'maintenanceEndPopup', notificationEnabled.checked ? 1 : 0 );

//        var settings = WidgetManager.getWidgetSettings('Messenger');

//        settings.save();

        var downloadManagerConnectorSettings = WidgetManager.getWidgetSettings('DownloadManagerConnector');
        downloadManagerConnectorSettings.gameUpdateFinishedNotification = gameUpdateFinishedNotificationCheckBox.checked;
        downloadManagerConnectorSettings.save();

//        var premiumNotifierSettings = WidgetManager.getWidgetSettings('PremiumNotifier');
//        premiumNotifierSettings.premiumExpiredNotification = protocolOnePremiumExpiedNotificationCheckBox.checked;
//        premiumNotifierSettings.save();

        var announcementsSettings = WidgetManager.getWidgetSettings('Announcements');
        announcementsSettings.showGameInstallNoExecuteReminder = gameInstalledNeverExecuteReminderCheckBox.checked;

        var now = Math.floor(+(Date.now()) / 1000);
        announcementsSettings.smallAnnouncementStopDate =
            smallAnouncementSetting.getValue(smallAnouncementSetting.currentIndex) == 'skipMonth'
            ? now
            : 0;

        announcementsSettings.bigAnnouncementStopDate =
            bigAnouncementSetting.getValue(bigAnouncementSetting.currentIndex) == 'skipMonth'
            ? now
            : 0;

        announcementsSettings.save();
    }

    function load() {
        //var settings = WidgetManager.getWidgetSettings('Messenger');

        notificationEnabled.checked = AppSettings.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true);

        gameUpdateFinishedNotificationCheckBox.checked =
                WidgetManager.getWidgetSettings('DownloadManagerConnector').gameUpdateFinishedNotification;

//        protocolOnePremiumExpiedNotificationCheckBox.checked =
//                WidgetManager.getWidgetSettings('PremiumNotifier').premiumExpiredNotification;

        var announcementsSettings = WidgetManager.getWidgetSettings('Announcements');
        gameInstalledNeverExecuteReminderCheckBox.checked = announcementsSettings.showGameInstallNoExecuteReminder;

        smallAnouncementSetting.currentIndex =
            smallAnouncementSetting.findValue(
                announcementsSettings.smallAnnouncementStopDate > 0
                    ? "skipMonth"
                    : "always");

        bigAnouncementSetting.currentIndex =
            bigAnouncementSetting.findValue(
                announcementsSettings.bigAnnouncementStopDate > 0
                    ? "skipMonth"
                    : "always");

    }

    function reset() {
        notificationEnabled.checked = true;
        gameUpdateFinishedNotificationCheckBox.checked = true;
        protocolOnePremiumExpiedNotificationCheckBox.checked = true;
        gameInstalledNeverExecuteReminderCheckBox.checked = true;

        smallAnouncementSetting.currentIndex = smallAnouncementSetting.findValue("always");
        bigAnouncementSetting.currentIndex = bigAnouncementSetting.findValue("always");
    }

    function smallAnnouncementStopDateValue() {
        var announcementsSettings = WidgetManager.getWidgetSettings('Announcements');
        return announcementsSettings.smallAnnouncementStopDate > 0
            ? "skipMonth"
            : "always";
    }

    function bigAnnouncementStopDateValue() {
        var announcementsSettings = WidgetManager.getWidgetSettings('Announcements');
        return announcementsSettings.bigAnnouncementStopDate > 0
            ? "skipMonth"
            : "always";
    }

    function setMarketingsParams(params) {
        params.maintenanceEnd = AppSettings.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true) ? "1" : "0";
        params.smallAnnouncement = root.smallAnnouncementStopDateValue() === "skipMonth" ? "1" : "0";
        params.bigAnnouncement = root.bigAnnouncementStopDateValue() === "skipMonth" ? "1" : "0";

        params.gameUpdateFinishedNotification =
            WidgetManager.getWidgetSettings('DownloadManagerConnector').gameUpdateFinishedNotification ? "1" : "0";

//        params.premiumExpiredNotification =
//            WidgetManager.getWidgetSettings('PremiumNotifier').premiumExpiredNotification ? "1" : "0";

        params.showGameInstallNoExecuteReminder =
            WidgetManager.getWidgetSettings('Announcements').showGameInstallNoExecuteReminder ? "1" : "0";

        return params;
    }

    ScrollArea {
        allwaysShown: true
        anchors {
            fill: parent
            bottomMargin: 62
        }

        Column {
            width: parent.width - 50
            spacing: 15

            SettingsCaption {
                text: qsTr("APPLICATION_SETTINGS_NOTIFICATION_GENERAL_TITLE")
                font.pixelSize: 14
            }

            CheckBox {
                id: notificationEnabled

                text: qsTr("CHECKBOX_NOTIFICATION_MAINTENANCE_END")
                checked: AppSettings.isAppSettingsEnabled('notifications', 'maintenanceEndPopup', true);
                onToggled: {
                    Ga.trackEvent('ApplicationSettings', 'toggle', 'Maintenance popup', checked|0);
                }
            }

            CheckBox {
                id: gameUpdateFinishedNotificationCheckBox

                text: qsTr("CHECKBOX_NOTIFICATION_GAME_UPDATE_FINISHED")
            }

//            CheckBox {
//                id: protocolOnePremiumExpiedNotificationCheckBox

//                text: qsTr("CHECKBOX_NOTIFICATION_PROTOCOLONE_PREMIUM_FINISHED")
//            }

            CheckBox {
                id: gameInstalledNeverExecuteReminderCheckBox

                text: qsTr("CHECKBOX_NOTIFICATION_GAME_NEVER_STARTED_REMINDER")
            }

            SettingsCaption {
                text: qsTr("APPLICATION_SETTINGS_NOTIFICATION_IMPORTANT_TITLE")
                font.pixelSize: 14
            }

            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("APPLICATION_SETTINGS_NOTIFICATION_IMPORTANT_DESCRIPTION")
                color: Styles.infoText
                font { family: "Arial"; pixelSize: 11 }
            }

            Item {
                width: parent.width
                height: 68
                z: 101

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    text: qsTr("APPLICATION_SETTINGS_NOTIFICATION_BIG_ANNOUNCEMENT_TITLE")
                    color: Styles.infoText
                }

                ComboBox {
                    id: bigAnouncementSetting

                    y: 20
                    width: parent.width
                    height: 48
                    dropDownSize: 5

                    Component.onCompleted: {
                        append("always", qsTr("APPLICATION_SETTINGS_NOTIFICATION_BIG_ANNOUNCEMENT_SHOW_ALWAYS"));
                        append("skipMonth", qsTr("не уведомлять"));
                    }
                }
            }

            Item {
                width: parent.width
                height: 68
                z: 100

                Text {
                    font {
                        family: "Arial"
                        pixelSize: 12
                    }

                    text: qsTr("APPLICATION_SETTINGS_NOTIFICATION_SMALL_ANNOUNCEMENT_TITLE")
                    color: Styles.infoText
                }

                ComboBox {
                    id: smallAnouncementSetting

                    y: 20
                    width: parent.width
                    height: 48
                    dropDownSize: 5

                    Component.onCompleted: {
                        append("always", qsTr("APPLICATION_SETTINGS_NOTIFICATION_SMALL_ANNOUNCEMENT_SHOW_ALWAYS"));
                        append("skipMonth", qsTr("не уведомлять"));
                    }
                }
            }

            Item {
                width: parent.width
                height: 80
            }
        }
    }
}
