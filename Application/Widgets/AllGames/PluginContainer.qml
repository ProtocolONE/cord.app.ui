import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "AllGames"
    view: [
        {name: 'AllGamesView', source: 'AllGamesView', byDefault: true},
        {name: 'VerticalListView', source: 'VerticalListView'}
    ]

    model: "AllGamesModel"
    singletonModel: true
}
