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
import QtQuick.Window 2.2

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0


WidgetModel {
    id: model

    property string serviceId

    function show(serviceId) {
        model.serviceId = serviceId;
        Popup.show("StandaloneGameShop");
    }

    Connections {
        target: SignalBus

        onBuyGame: model.show(serviceId)
    }
}
