/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../../Application/Core/App.js" as App

Rectangle {
    width: 800
    height: 800
    color: '#cccccc'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            var oldActivateByServiceId = App.activateGameByServiceId;
            App.activateGameByServiceId = function(serviceId) {
                console.log("Activate service: " + serviceId);
                oldActivateByServiceId(serviceId);
            }

            manager.registerWidget('Application.Widgets.Maintenance');

            manager.init();
            App.activateGame(App.serviceItemByGameId("92"));
        }
    }

    WidgetContainer {
        x: 50
        y: 50

        width: 590
        height: 100
        widget: 'Maintenance'
        view: 'MaintenanceLightView'
    }

}
