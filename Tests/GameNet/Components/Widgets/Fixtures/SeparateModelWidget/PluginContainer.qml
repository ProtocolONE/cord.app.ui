import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "SeparateModelWidget"
    model: "WidgetModel"
    singletonModel: false
    view: [
        {name: 'ViewOne', source: 'ViewOne', byDefault: true},
        {name: 'ViewTwo', source: 'ViewTwo'}
    ]
}
