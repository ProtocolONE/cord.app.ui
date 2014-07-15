/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import Application.Blocks 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../Core/TrayPopup.js" as TrayPopup
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

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
        }
    }

    Component {
        id: gameDownloadingPopup

        GamePopup {
            id: popUp

            state: "Orange"

            onPlayClicked: {
                GoogleAnalytics.trackEvent('/announcement/silentmode', 'Announcement', 'Play');
            }
            onCloseButtonClicked: {
                GoogleAnalytics.trackEvent('/announcement/silentmode', 'Announcement', 'Close');
            }
        }
    }

    Connections {
        target: App.signalBus();

        onServiceInstalled: {
            if (!App.isWindowVisible()) {
                if (App.isSilentMode()) {
                    delayedActivateApp.activateServiceId = gameItem.serviceId;
                    delayedActivateApp.start();
                }
            }
        }

        onDownloaderStarted: {
            var isInstalled = App.isServiceInstalled(gameItem.serviceId);

            if (App.isSilentMode() && !isInstalled) {
                d.showPopupGameDownloading(gameItem);
                App.hideMainWindow();
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
