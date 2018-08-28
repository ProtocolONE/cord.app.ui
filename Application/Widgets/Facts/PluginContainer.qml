import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "Facts"
    view: "FactsView"
    model: "FactsModel"
    singletonModel: true
}
