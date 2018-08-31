import QtQuick 2.4
import Dev 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 800
    color: '#EEEEEE'

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("1073"));
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
            WidgetManager.registerWidget('Application.Widgets.GameInstall');
            WidgetManager.init();

            MessageBox.init(messageLayer);
            Popup.init(popupLayer);

        }
    }

//    WidgetContainer {
//        x: 182
//        y: 115
//        width: 629
//        height: 375
//        widget: 'GameInstall'
//    }

    Row {
        x: 50
        y: 50

        spacing: 20

        Button {
            text: "Show"
            onClicked: App.mainWindowInstance().showLicense("370000000000")
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }

    Item {
        id: messageLayer

        anchors.fill: parent
    }
}
