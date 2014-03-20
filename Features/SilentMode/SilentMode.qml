import QtQuick 1.1
import Tulip 1.0
import "../../Elements" as Elements
import "../../Blocks/Features/Announcements"

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
    }

    Component {
        id: gameDownloadingPopup

        Elements.GameItemPopUp {
            id: popUp

            state: "Orange"
        }
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
                d.showPopupGameDownloading(service);
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
}
