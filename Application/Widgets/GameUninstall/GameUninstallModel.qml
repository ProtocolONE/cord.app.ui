import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0

WidgetModel {
    id: root

    QtObject {
        id: d

        function onUninstallRequest(serviceId, fromOs) {
            var item = App.serviceItemByServiceId(serviceId);
            if (!item) {
                console.log('onUninstallRequest error - unknown service: ' + serviceId)
                return;
            }

            var isInstalled = ApplicationStatistic.isServiceInstalled(serviceId);
            if (!isInstalled) {
                MessageBox.show(qsTr("WARNING_UNINSTALL_NOT_INSTALLED_TITLE"),
                                qsTr("WARNING_UNINSTALL_NOT_INSTALLED_MESSAGE").arg(item.name),
                                MessageBox.button.ok);
                App.cancelServiceUninstall(serviceId);
                return;
            }

            if (item.status === "Uninstalling") {
                MessageBox.show(qsTr("WARNING_UNINSTALL_INPROGRESS_TITLE"),
                                qsTr("WARNING_UNINSTALL_INPROGRESS_MESSAGE").arg(item.name),
                                MessageBox.button.ok);
              App.cancelServiceUninstall(serviceId);
              return;
            }

            if (item.status === "Downloading" || item.status === "Paused") {
                MessageBox.show(qsTr("WARNING_GAME_ISDOWNLOADING_TITLE"),
                                qsTr("WARNING_GAME_ISDOWNLOADING_MESSAGE").arg(item.name),
                                MessageBox.button.ok);
                App.cancelServiceUninstall(serviceId);
                return;
            }

            if (App.isServiceRunning(serviceId)) {
                MessageBox.show(qsTr("WARNING_GAME_ISRUNNING_TITLE"),
                                qsTr("WARNING_GAME_ISRUNNING_MESSAGE").arg(item.name),
                                MessageBox.button.ok);
                App.cancelServiceUninstall(serviceId);
                return;
            }


            MessageBox.show(qsTr("WARNING_QUESTION_TITLE"),
                            qsTr("WARNING_QUESTION_MESSAGE").arg(item.name),
                            MessageBox.button.yes | MessageBox.button.no,
                            function(result) {
                                if (result == MessageBox.button.yes) {
                                    if (fromOs) {
                                        Marketing.send(Marketing.ServiceUninstalledFromOS, serviceId, {userId: User.userId()});
                                    } else {
                                        Marketing.send(Marketing.ServiceUninstalledFromUI, serviceId, {userId: User.userId()});
                                    }
                                    App.uninstallService(serviceId);
                                } else {
                                    App.cancelServiceUninstall(serviceId);
                                }
                            });
        }
    }

    Connections {
        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

        onUninstallServiceRequest: d.onUninstallRequest(serviceId, true);
    }

    Connections {
        target: SignalBus
        ignoreUnknownSignals: true

        onUninstallStarted: {
            var gameSettingsModel = App.gameSettingsModelInstance();
            if (!gameSettingsModel) {
                return;
            }

            gameSettingsModel.removeShortcuts(serviceId);
        }

        onUninstallRequested: {
            d.onUninstallRequest(serviceId, false);
        }
    }
}
