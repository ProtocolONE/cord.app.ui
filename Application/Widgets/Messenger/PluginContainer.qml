import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "Messenger"
    model: "Model"
    singletonModel: true
    view: [
        {name: 'Contacts', source: 'Contacts', byDefault: true},
        {name: 'Chat', source: 'Chat'},
        {name: 'GameNetNotification', source: 'GameNetNotification'}
    ]
}
