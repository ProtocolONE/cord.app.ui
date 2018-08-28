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
                if (App.isSilentMode()) {
                    App.forceDownload(serviceId);
                    return;
                }

                App.downloadButtonStart(serviceId);
            }
            root.isFirstRun = false;
        }
        onServiceCanceled: AppSettings.setValue('RememberGameDownloading', 'service', false);
        onServiceInstalled: AppSettings.setValue('RememberGameDownloading', 'service', false);
        onDownloaderStarted: {
            AppSettings.setValue('RememberGameDownloading', 'service', gameItem.serviceId);
        }
    }

    Connections {
        target: App.mainWindowInstance()

        ignoreUnknownSignals: true
        onDownloaderFinished: AppSettings.setValue('RememberGameDownloading', 'service', false);
    }
}
