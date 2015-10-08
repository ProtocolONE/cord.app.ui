/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2015, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import Application.Core 1.0
import Application.Core.Settings 1.0

WidgetModel {
    id: root

    property bool isFirstRun: true

    Connections {
        target: SignalBus
        ignoreUnknownSignals: true

        onAuthDone: {
            if (App.startingService() !== "0" || !root.isFirstRun) {
                //INFO Не стартуем, если приложение запустили с аргументом командой строки starservice или не первый
                //запуск.
                return;
            }

            var serviceId = AppSettings.value('RememberGameDownloading', 'service');
            if (serviceId && App.serviceExists(serviceId) && !ApplicationStatistic.isServiceInstalled(serviceId)) {
                App.downloadButtonStart(serviceId);
            }
            root.isFirstRun = false;
        }
        onServiceCanceled: AppSettings.setValue('RememberGameDownloading', 'service', false);
        onServiceInstalled: AppSettings.setValue('RememberGameDownloading', 'service', false);
        onServiceStarted: {
            if (serviceItem.gameType != 'standalone') {
                return;
            }
            AppSettings.setValue('RememberGameDownloading', 'service', gameItem.serviceId);
        }
    }
}
