/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Blocks 1.0
import Application.Core 1.0

Item {
    width: 1000
    height: 599

    WidgetManager {
        id: manager

        Component.onCompleted: {
            App.activateGame(App.serviceItemByGameId("92"));
            showPopupTimer.start();
        }
    }

    Timer {
        id: showPopupTimer

        repeat: false
        interval: 2000
        onTriggered:  {
            var gameItem = App.serviceItemByGameId("92");
            var popUpOptions;

            popUpOptions = {
                gameItem: gameItem,
                destroyInterval: 5000,
                buttonCaption: "Играть!",
                message: "Зарубись прям тут!"
            };

            TrayPopup.showPopup(gameDownloadingPopup, popUpOptions, 'gameDownloading' + gameItem.serviceId);
        }
    }

    Component {
        id: gameDownloadingPopup

        GamePopup {
            id: popUp
        }
    }
}
