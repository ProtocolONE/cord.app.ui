import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import Application.Controls 1.0

ScrollArea {
    id: root

    property variant currentGame
    property bool hasCurrentGame: !!currentGame

    implicitWidth: 590
    implicitHeight: 489 + 30

    WidgetContainer {
        visible: root.hasCurrentGame
                 && root.currentGame.maintenance
                 && (root.currentGame.allreadyDownloaded || root.currentGame.maintenanceSettings.isSticky)

        widget: visible ? 'Maintenance' : ''
        view: 'MaintenanceLightView'
    }

    WidgetContainer {
        widget: 'GameAdBanner'
    }

    WidgetContainer {
        width: parent.width
        widget: 'GameNews'
    }
}
