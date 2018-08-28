import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "GameNews"
    model: "GameNewsModel"
    view: [
        {name: 'NewsSingleGame', source: 'NewsSingleGame', byDefault: true},
    ]
    singletonModel: true
}
