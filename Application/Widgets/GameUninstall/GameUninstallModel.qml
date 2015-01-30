/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0

import "../../Core/App.js" as App
import "../../Core/User.js" as User
import "../../Core/MessageBox.js" as MessageBox

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

            var isInstalled = App.isServiceInstalled(serviceId);
            if (!isInstalled) {
                MessageBox.show(qsTr("WARNING_UNINSTALL_NOT_INSTALLED_TITLE"),
                                qsTr("WARNING_UNINSTALL_NOT_INSTALLED_MESSAGE").arg(item.name),
                                MessageBox.button.Ok);
                App.cancelServiceUninstall(serviceId);
                return;
            }

            if (item.status === "Uninstalling") {
                MessageBox.show(qsTr("WARNING_UNINSTALL_INPROGRESS_TITLE"),
                                qsTr("WARNING_UNINSTALL_INPROGRESS_MESSAGE").arg(item.name),
                                MessageBox.button.Ok);
              App.cancelServiceUninstall(serviceId);
              return;
            }

            if (item.status === "Downloading" || item.status === "Paused") {
                MessageBox.show(qsTr("WARNING_GAME_ISDOWNLOADING_TITLE"),
                                qsTr("WARNING_GAME_ISDOWNLOADING_MESSAGE").arg(item.name),
                                MessageBox.button.Ok);
                App.cancelServiceUninstall(serviceId);
                return;
            }

            if (App.runningService[serviceId]) {
                MessageBox.show(qsTr("WARNING_GAME_ISRUNNING_TITLE"),
                                qsTr("WARNING_GAME_ISRUNNING_MESSAGE").arg(item.name),
                                MessageBox.button.Ok);
                App.cancelServiceUninstall(serviceId);
                return;
            }


            MessageBox.show(qsTr("WARNING_QUESTION_TITLE"),
                            qsTr("WARNING_QUESTION_MESSAGE").arg(item.name),
                            MessageBox.button.Yes | MessageBox.button.No,
                            function(result) {
                                if (result == MessageBox.button.Yes) {
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
        target: App.signalBus()
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
