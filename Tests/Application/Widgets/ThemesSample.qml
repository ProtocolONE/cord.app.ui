import QtQuick 2.4
import Dev 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Rectangle {
    width: App.clientWidth
    height: App.clientHeight
    color: Styles.applicationBackground

    Component.onDestruction: {
        console.log('--------- destroy')
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Themes2');
            manager.init();

            SignalBus.authDone('400001000005869460', 'fac8da16caa762f91607410d2bf428fb7e4b2c5e', '')
        }
    }

    Row {
        width: parent.width
        height: 50
        spacing: 10


        Button {
            width: 50
            height: 50
            text: "Load"
            onClicked: widget.widget = 'Themes';

        }

        Button {
            width: 50
            height: 50
            text: "Unload"
            onClicked: {
                widget.reset()
            }
        }
    }

    WidgetContainer {
        id: widget

        anchors {
            fill: parent
            topMargin: 50
        }
    }
}
