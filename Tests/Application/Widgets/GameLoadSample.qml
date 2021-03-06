import QtQuick 2.4
import Tulip 1.0

import Dev 1.0

import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    Component.onCompleted: {
        Popup.init(popupLayer);
        MessageBox.init(messageBoxLayer)

        WidgetManager.registerWidget('Application.Widgets.ApplicationSettings');
        WidgetManager.registerWidget('Application.Widgets.AutoMinimize');
        WidgetManager.registerWidget('Application.Widgets.Announcements');
        WidgetManager.registerWidget('Application.Widgets.DownloadManagerConnector');
        WidgetManager.registerWidget('Application.Widgets.PremiumNotifier');
        WidgetManager.registerWidget('Application.Widgets.Messenger');
        WidgetManager.registerWidget('Application.Widgets.Overlay');

        WidgetManager.registerWidget('Application.Widgets.GameAdBanner');
        WidgetManager.registerWidget('Application.Widgets.GameLoad');
        WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
        WidgetManager.init();
    }

    RequestServices {
        onReady: {
            var serviceItem = App.serviceItemByGameId("92");
            serviceItem.statusText = "Sample text";

            App.activateGame(serviceItem);
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            console.log("Closed popupId: " + popupId);
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }

        Button {
            x: 10
            y: 98
            width: 160
            height: 36
            text: 'Начать игру'
            onClicked: Popup.show('GameLoad');
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageBoxLayer

        anchors.fill: parent
        z: 3
    }
}
