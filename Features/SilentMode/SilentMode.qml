import QtQuick 1.1
import Tulip 1.0
import "../../Elements" as Elements

import "../../Proxy/App.js" as App
import "../../js/Core.js" as Core
import "../../js/PopupHelper.js" as PopupHelper
import "../../js/GoogleAnalytics.js" as GoogleAnalytics

Item {
    id: root

    width: 100
    height: 62

    signal playClicked(string serviceId);
    signal missClicked(string serviceId)

    QtObject {
        id: d

        function setShown() {
            var today = Qt.formatDate(new Date(), "yyyy-MM-dd");
            Settings.setValue("qml/features/SilentMode", "showDate", today);
        }

        function isShownToday() {
            var today = Qt.formatDate(new Date(), "yyyy-MM-dd");
            var showDate = Settings.value("qml/features/SilentMode", "showDate", 0);
            return (today == showDate);
        }

        function shouldRemind() {
            var installDate = Settings.value('qGNA', 'installDate', 0);
            if (!installDate) {
                return false;
            }

            var duration = Math.floor((+ new Date()) / 1000) - installDate;
            return duration > 86400;
        }

        function getRandomInt(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        function shouldShowArtPopup() {
            var tmp = d.getRandomInt(0, 1000);
            return tmp < 500;
        }

        function remind() {
            if (!App.isSilentMode() || App.isAnyLicenseAccepted()) {
                remindTimer.stop();
                return;
            }

            if (!d.shouldRemind()) {
                return;
            }

            if (d.isShownToday()) {
                return;
            }

            if (App.isWindowVisible()) {
                return;
            }

            d.setShown();

            var installDate = Settings.value('qGNA', 'installDate', 0),
                currentDate = Math.floor((+ new Date()) / 1000);


            var serviceId = "300012010000000000",
                gameItem = Core.serviceItemByServiceId(serviceId),
                popUpOptions;

            var type, popupComponent;
            if (d.shouldShowArtPopup()) {
                popupComponent = artRemind;
                type = "art";
            } else {
                popupComponent = smallGreenRemind;
                type = "green";
            }

            var page = ('/silenceMode/reminder/%1/%2').arg(type).arg(serviceId)

            popUpOptions = {
                gameItem: gameItem,
                page: page,
                buttonCaption: qsTr("SILENT_REMIND_POPUP_BUTTON"),
                message: qsTr("SILENT_REMIND_POPUP_MESSAGE").arg(gameItem.licenseUrl)
            };

            PopupHelper.showPopup(popupComponent, popUpOptions, 'silentModeRemider' + serviceId);
        }
    }

    Component {
        id: smallGreenRemind

        GreenPopup {
            id: popUp

            property string page

            onPlayClicked: {
                root.playClicked(popUp.gameItem.serviceId);
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Action on Announcement', gameItem.gaName);
            }

            onAnywhereClicked: {
                root.missClicked(popUp.gameItem.serviceId);
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Miss Click On Announcement', gameItem.gaName);
            }

            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Close Announcement', gameItem.gaName);
            }

            Component.onCompleted: {
                GoogleAnalytics.trackEvent(page, 'Announcement', 'Show Announcement', gameItem.gaName);
            }
        }
    }

    Component {
        id: artRemind

        ArtPopup {
            id: popUp

            property string page

            onPlayClicked: {
                root.playClicked(popUp.gameItem.serviceId);
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Action on Announcement', gameItem.gaName);
            }

            onAnywhereClicked: {
                root.missClicked(popUp.gameItem.serviceId);
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Miss Click On Announcement', gameItem.gaName);
            }

            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent(popUp.page, 'Announcement', 'Close Announcement', gameItem.gaName);
            }

            Component.onCompleted: {
                GoogleAnalytics.trackEvent(page, 'Announcement', 'Show Announcement', gameItem.gaName);
            }
        }
    }

    Component {
        id: gameDownloadingPopup

        Elements.GameItemPopUp {
            id: popUp

            state: "Orange"
        }
    }

    function showPopupGameDownloading(serviceId) {
        var gameItem = Core.serviceItemByServiceId(serviceId),
            popUpOptions;

        popUpOptions = {
            gameItem: gameItem,
            destroyInterval: 5000,
            buttonCaption: qsTr("SILENT_DOWNLOADING_POPUP_BUTTON"),
            message: qsTr("SILENT_DOWNLOADING_POPUP_TEXT")
        };

        PopupHelper.showPopup(gameDownloadingPopup, popUpOptions, 'gameDownloading' + serviceId);
    }

    Connections {
        target: mainWindow

        onServiceInstalled: {
            if (!App.isWindowVisible()) {
                if (App.isSilentMode()) {
                    delayedActivateApp.activateServiceId = serviceId
                    delayedActivateApp.start();
                }
            }
        }

        onDownloaderStarted: {
            var isInstalled = Core.isServiceInstalled(service);
            if (App.isSilentMode() && !isInstalled) {
                root.showPopupGameDownloading(service);
                Core.hideMainWindow();
            }
        }
    }

    Timer {
        id: delayedActivateApp

        property string activateServiceId

        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            if (!App.isWindowVisible()) {
                if (App.isSilentMode()) {
                    Core.activateGameByServiceId(delayedActivateApp.activateServiceId);
                    App.activateWindow();
                }
            }
        }
    }

    Timer {
        id: remindTimer

        interval: 60000
        running: true
        repeat: true
        onTriggered: d.remind();
    }
}
