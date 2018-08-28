import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "GameInstall"
    view: "GameInstallView"
    model: "GameInstallModel"
    singletonModel: true
}
