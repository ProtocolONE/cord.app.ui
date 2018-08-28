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
                App.openExternalUrlWithAuth(Config.GnUrl.site("/pay/"));
            }
        }
    }
}
