import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

ScrollArea {
    id: root

    property variant currentGame
    property bool hasCurrentGame: !!currentGame

    width: 590
    height: 600

    WidgetContainer {
        visible: root.hasCurrentGame
                 && root.currentGame.maintenance
                 && root.currentGame.allreadyDownloaded

        widget: 'Maintenance'
        view: 'MaintenanceLightView'
    }

    WidgetContainer {
        widget: 'GameAdBanner'
    }

    WidgetContainer {
        widget: 'Facts'
    }

    WidgetContainer {
        width: parent.width
        widget: 'GameNews'
    }
}
