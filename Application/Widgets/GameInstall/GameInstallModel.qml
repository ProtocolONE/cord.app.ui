import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0

WidgetModel {
    id: root

    property variant mainWindowInstance: App.mainWindowInstance()

    Connections {
        target: root.mainWindowInstance || null
        ignoreUnknownSignals: true

        onShowLicense: {
            var gameItem = App.serviceItemByServiceId(serviceId);
            App.activateGame(gameItem);

//            if (gameItem.isStandalone && !User.hasBoughtStandaloneGame(serviceId)) {
//                SignalBus.buyGame(serviceId);
//                return;
//            }

            Popup.show('GameInstall');
        }
    }
}
