import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "SingletonModelWidget"
    model: "WidgetModel"
    singletonModel: true
    view: [
        {name: 'ViewOne', source: 'ViewOne', byDefault: true},
        {name: 'ViewTwo', source: 'ViewTwo'}
    ]
}
