import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "ApplicationSettings"
    model: "ApplicationSettingsModel"
    view: "ApplicationSettingsView"
    singletonModel: true
}
