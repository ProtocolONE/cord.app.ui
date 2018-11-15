import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0
import Application.Controls 1.0

ScrollArea {
    implicitWidth: 590
    implicitHeight: 489 + 30

    WidgetContainer {
        widget: 'GameInfo'
    }

    WidgetContainer {
        widget: 'GameNews'
    }
}
