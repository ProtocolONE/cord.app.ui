import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "StandaloneGameShop"
    view: "StandaloneGameShopView"
    model: "StandaloneGameShopModel"
    singletonModel: true
}
