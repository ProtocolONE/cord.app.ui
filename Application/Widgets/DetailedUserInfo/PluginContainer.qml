import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "DetailedUserInfo"
    view: "DetailedUserInfoView"
    model: "DetailedUserInfoModel"
    singletonModel: true
}
