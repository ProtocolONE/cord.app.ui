import QtQuick 2.4

import Application.Core 1.0
import Application.Core.MessageBox 1.0

import GameNet.Components.Widgets 1.0

WidgetModel {
    id: root

    Connections {
        target: SignalBus
        onTerminateGame: {
            if (!App.serviceExists(serviceId)) {
                return;
            }

            var service = App.serviceItemByServiceId(serviceId);
            App.terminateGame(serviceId);
            var defaultMessage = qsTr("GAME_CONTROL_REMOTE_STOP").arg(service.name)
            MessageBox.show(
                        qsTr("INFO_CAPTION"),
                        message || defaultMessage,
                        MessageBox.button.ok);
        }

        onTerminateAllGame: {
            App.terminateGame("");
            var defaultMessage = qsTr("GAME_CONTROL_REMOTE_ALL_STOP");
            MessageBox.show(
                        qsTr("INFO_CAPTION"),
                        message || defaultMessage,
                        MessageBox.button.ok);
        }
    }
}
