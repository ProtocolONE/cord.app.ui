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
import Application.Blocks 1.0

import "../../../Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../Core/App.js" as App

GamePopup {
    id: popUp

    function gaEvent(name) {
        GoogleAnalytics.trackEvent('/announcement/gameMaintenanceEndShow/' + gameItem.serviceId,
                                   'Announcement', name, gameItem.gaName);
    }

    Connections {
        target: mainWindow
        onServiceStarted: {
            if (gameItem.serviceId == service) {
                shadowDestroy();
            }
        }
    }

    state: "Green"
    onAnywhereClicked: gaEvent('Miss Click On Announcement')
    onCloseButtonClicked: gaEvent('Close Announcement')
    onPlayClicked: {
        gaEvent('Action on Announcement');
        App.activateWindow();
        App.activateGame(gameItem);
        App.executeService(gameItem.serviceId);
    }
}
