import QtQuick 2.4
import Dev 1.0
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 1
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.PremiumNotifier');
            manager.registerWidget('Application.Widgets.PremiumShop');
            manager.init();

            Popup.init(popupLayer);
            emulateTimer.start();
        }
    }

	Timer {
        id: emulateTimer

        interval: 2000
        repeat: false
        onTriggered: {
            SignalBus.premiumExpired();
        }
	}
}
