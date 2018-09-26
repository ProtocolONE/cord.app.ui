import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Config 1.0

WidgetModel {
    id: root

    signal openMoneyOverlay();

    Connections {
        target: SignalBus
        onNavigate: {
            if (link == 'goprotocolonemoney') {
                App.openExternalUrlWithAuth(Config.site("/pay/"));
            }
        }
    }
}
