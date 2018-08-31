import QtQuick 2.4
import Tulip 1.0

import Application 1.0
import Dev 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('sand');
        Popup.init(popupLayer);
        Tooltip.init(tooltipLayer);
        MessageBox.init(messageboxLayer);
    }

    RequestServices {
        onReady: {
            var serviceItem = App.serviceItemByGameId("71");
            serviceItem.statusText = "Sample text";

            App.activateGame(serviceItem);
        }
    }

    Item {
        id: manager

        Component.onCompleted: {
            WidgetManager.registerWidget('Application.Widgets.ApplicationSettings');
            WidgetManager.registerWidget('Application.Widgets.AutoMinimize');
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
            WidgetManager.registerWidget('Application.Widgets.Announcements');
            WidgetManager.registerWidget('Application.Widgets.DownloadManagerConnector');
            WidgetManager.registerWidget('Application.Widgets.PremiumNotifier');
            WidgetManager.registerWidget('Application.Widgets.Messenger');
            WidgetManager.registerWidget('Application.Widgets.Overlay');
            WidgetManager.init();
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            console.log("Closed popupId: " + popupId);
        }
    }

    Flow {
        id: baseLayer

        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Button {
            text: 'Настройки Приложения'
            onClicked: Popup.show('ApplicationSettings');
        }

        Button {
            text: "getIgnoreList"
            onClicked: {

                RestApi.User.getIgnoreList(function(res) {
                    console.log('IgnoreList ', JSON.stringify(res, null, 2))
                });
            }
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageboxLayer

        anchors.fill: parent
        z: 3
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
        z: 4
    }

//    Bootstrap {
//        anchors.fill: parent
//    }
}
