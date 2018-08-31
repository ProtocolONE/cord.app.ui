import QtQuick 2.4
import QtQuick.Window 2.2

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

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
