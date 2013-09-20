import QtQuick 1.1
import "AppProxy.js" as AppProxy

Item {
    id: root

    Loader {
        id: proxyLoader

        source: "Loaders/MainApp.qml"

        onLoaded: {
            if (status !== Loader.Ready) {
                return;
            }

            AppProxy.mainWindow = proxyLoader.item.mainWindowLoader;
            AppProxy.licenseModel = proxyLoader.item.licenseModelLoader;
            AppProxy.settingsViewModel = proxyLoader.item.settingsViewModelLoader;
            AppProxy.gameSettingsModel = proxyLoader.item.gameSettingsModelLoader;
        }
    }
}
