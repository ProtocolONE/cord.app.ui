import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import "../../../Application/Core/Popup.js" as Popup
Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            Popup.init(popupLayer);
            manager.registerWidget('Application.Widgets.P2PCancelRequest');
            manager.init();
        }
    }

    Button {
        x: 50
        y: 50
        width: 100
        height: 30
        text: "Open"

        onClicked: Popup.show("P2PCancelRequest")
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }
}
