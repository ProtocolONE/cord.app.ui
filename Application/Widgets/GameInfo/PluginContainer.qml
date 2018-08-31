import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "GameInfo"
    view: "GameInfoView"
    model: "GameInfoModel"
    singletonModel: true
}
