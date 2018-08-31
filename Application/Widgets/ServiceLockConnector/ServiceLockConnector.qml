import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

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
