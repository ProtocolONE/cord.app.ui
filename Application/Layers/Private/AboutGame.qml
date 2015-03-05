import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

ScrollArea {
    width: 590
    height: 600

    WidgetContainer {
        widget: 'GameInfo'
    }

    WidgetContainer {
        widget: 'GameNews'
    }
}
