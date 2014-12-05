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
import qGNA.Library 1.0
import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App

WidgetModel {
    id: root

    ServiceHandle {
        onServiceLocked: {
            var gameItem = App.serviceItemByServiceId(serviceId);

            if (!gameItem) {
                return;
            }

            gameItem.locked = true;
        }

        onServiceUnlocked: {
            var gameItem = App.serviceItemByServiceId(serviceId);

            if (!gameItem) {
                return;
            }

            gameItem.locked = false;

        }
    }
}
