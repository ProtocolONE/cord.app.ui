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
import GameNet.Core 1.0

import Application.Blocks 1.0
import Application.Core 1.0

GamePopup {
    id: popUp

    function gaEvent(name) {
        Ga.trackEvent('Announcement GgameMaintenanceEndShow', name, gameItem.gaName);
    }

    Connections {
        target: mainWindow
        onServiceStarted: {
            if (gameItem.serviceId == service) {
                shadowDestroy();
            }
        }
    }

    onAnywhereClicked: gaEvent('miss click')
    onCloseButtonClicked: gaEvent('close')
    onPlayClicked: {
        gaEvent('play');
        App.activateWindow();
        App.activateGame(gameItem);
        App.executeService(gameItem.serviceId);
    }
}
