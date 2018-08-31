import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

WidgetModel {
    property int counter: 0

    Timer {
        running: true
        repeat: true
        interval: 500
        onTriggered: counter++
    }
}
