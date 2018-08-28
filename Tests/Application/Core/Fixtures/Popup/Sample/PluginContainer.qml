import QtQuick 2.4
import Tests.Application.Core.Fixtures.Popup.Sample 1.0
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "SomeWidget"
    view: "SomeWidgetView"
    model: "SomeWidgetModel"
    singletonModel: true
}
