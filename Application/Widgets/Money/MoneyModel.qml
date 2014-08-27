import QtQuick 1.1
import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App
import "../../Core/restapi.js" as RestApi

WidgetModel {
    id: root

    signal openMoneyOverlay();

    Connections {
        target: App.signalBus()
        onNavigate: {
            if (link == 'gogamenetmoney') {
                RestApi.Billing.isInGameRefillAvailable(function(response) {
                    if (App.isOverlayEnabled() && response && !!response.enabled) {
                        root.openMoneyOverlay();
                        return;
                    }

                    App.openExternalUrlWithAuth("http://www.gamenet.ru/money")
                }, function() {
                    App.openExternalUrlWithAuth("http://www.gamenet.ru/money");
                });
            }
        }
    }
}