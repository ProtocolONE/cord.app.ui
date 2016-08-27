/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

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

//        onServiceInstalled: {
//            if (!App.isWindowVisible()) {
//                if (App.isSilentMode()) {
//                    delayedActivateApp.activateServiceId = gameItem.serviceId;
//                    delayedActivateApp.start();
//                }
//            }
//        }

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
