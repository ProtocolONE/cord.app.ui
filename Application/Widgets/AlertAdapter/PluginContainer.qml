import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "AlertAdapter"
    view: "AlertAdapterView"
    model: "AlertAdapterModel"
    singletonModel: true
}
