import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "DualViewWidget"
    view: [
        {name: 'ViewOne', source: 'ViewOne'},
        {name: 'ViewTwo', source: 'ViewTwo', byDefault: true}
    ]
}
