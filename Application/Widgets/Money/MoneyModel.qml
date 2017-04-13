import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

WidgetModel {
    id: root

    signal openMoneyOverlay();

    Connections {
        target: SignalBus
        onNavigate: {
            if (link == 'gogamenetmoney') {
                RestApi.Billing.isInGameRefillAvailable(function(response) {
                    if (App.isOverlayEnabled()
                            && response
                            && !!response.enabled
                            && false // INFO временно выключенно, пока будет исправлено пополнение GN-8648
                       ) {
                        root.openMoneyOverlay();
                        return;
                    }

                    App.openExternalUrlWithAuth(Config.GnUrl.site("/money/"));
                }, function() {
                    App.openExternalUrlWithAuth(Config.GnUrl.site("/money/"));
                });
            }
        }
    }
}
