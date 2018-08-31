import QtQuick 2.4
import Dev 1.0
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1200
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Money');
            manager.init();

            SignalBus.authDone("400001000092302250", "86c558d41c1ae4eafc88b529e12650b884d674f5");

            //  Мокаем нужные функции
            AppJs.isPublicVersion = function() {
                return false;
            }
            AppJs.isWindowVisible = function() {
                return true;
            }
            RestApi.Billing.isInGameRefillAvailable = function(fn) {
                fn({enabled: true})
            }

            runMoney.start();
        }
    }

    WidgetContainer {
        width: 590
        height: 400
        widget: 'Money'
    }

    Timer {
        id: runMoney

        repeat: false
        interval: 1000
        onTriggered: SignalBus.navigate("goprotocolonemoney", '');
    }
}
