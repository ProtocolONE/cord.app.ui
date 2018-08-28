import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0

WidgetModel {
    id: root

    width: 100
    height: 62

    QtObject {
        id: d

        function showPopupGameDownloading(gameItem) {
            var popUpOptions;

            popUpOptions = {
                gameItem: gameItem,
                destroyInterval: 5000,
                buttonCaption: qsTr("SILENT_DOWNLOADING_POPUP_BUTTON"),
                message: qsTr("SILENT_DOWNLOADING_POPUP_TEXT")
            };

            TrayPopup.showPopup(gameDownloadingPopup, popUpOptions, 'gameDownloading' + gameItem.serviceId);
            Ga.trackEvent('Announcement GameDownloading', 'show', gameItem.gaName);
        }
    }

    Component {
        id: gameDownloadingPopup

        GamePopup {
            id: popUp

            onPlayClicked: {
                Ga.trackEvent('Announcement GameDownloading', 'play', gameItem.gaName);
            }
            onCloseButtonClicked: {
                Ga.trackEvent('Announcement GameDownloading', 'close', gameItem.gaName);
            }
        }
    }

    Connections {
        target: SignalBus;
        onDownloaderStarted: {
            var isInstalled = ApplicationStatistic.isServiceInstalled(gameItem.serviceId);

            if (App.isSilentMode() && !isInstalled) {
                d.showPopupGameDownloading(gameItem);
                SignalBus.hideMainWindow();
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
                    App.activateGameByServiceId(delayedActivateApp.activateServiceId);
                    App.activateWindow();
                }
            }
        }
    }
}
