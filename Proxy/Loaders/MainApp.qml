import QtQuick 1.1
import qGNA.Library 1.0
import "../AppProxy.js" as AppProxy

Item {
    id: root

    property QtObject mainWindowLoader: mainWindow
    property QtObject licenseModelLoader: licenseModel
    property QtObject settingsViewModelLoader: settingsViewModel
    property QtObject gameSettingsModelLoader: gameSettingsModel

    Component.onCompleted: {
        AppProxy.Message = Message;
    }
}
