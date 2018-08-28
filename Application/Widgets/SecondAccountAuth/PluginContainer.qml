import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "SecondAccountAuth"
    view: [
        {name: 'SecondAccountAuthView', source: 'SecondAccountAuthView', byDefault: true},
        {name: 'SecondAccountView', source: 'SecondAccountView'}
    ]

    model: "SecondAccountAuthModel"
    singletonModel: true
}
