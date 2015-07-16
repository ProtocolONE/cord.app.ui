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
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    Connections {
        target: ServiceHandleModel

        ignoreUnknownSignals: true

        onServiceLocked: {
            var gameItem = App.serviceItemByServiceId(serviceId);

            if (!gameItem) {
                console.log('ERROR: serviceLocked() received for unknown service: ' + serviceId);
                return;
            }

            gameItem.locked = true;
        }

        onServiceUnlocked: {
            var gameItem = App.serviceItemByServiceId(serviceId);

            if (!gameItem) {
                console.log('ERROR: serviceUnlocked() received for unknown service: ' + serviceId);
                return;
            }

            gameItem.locked = false;

        }
    }
}
