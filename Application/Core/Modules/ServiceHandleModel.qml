pragma Singleton

import QtQuick 2.4

Item {
    id: root

    signal serviceLocked(string serviceId);
    signal serviceUnlocked(string serviceId);

    Loader {
        id: wrapper

        source: "./ServiceHandleModelPrivate.qml"
    }

    Connections {
        target: wrapper.item

        onServiceLocked: root.serviceLocked(serviceId)
        onServiceUnlocked: root.serviceUnlocked(serviceId);
    }
}
