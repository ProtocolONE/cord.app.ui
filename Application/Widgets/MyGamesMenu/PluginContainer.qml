import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "MyGamesMenu"
    view: "MyGamesMenuView"
    model: "MyGamesMenuModel"
    singletonModel: true
}
