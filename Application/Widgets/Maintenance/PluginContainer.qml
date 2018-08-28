import QtQuick 2.4
import GameNet.Components.Widgets 1.0

PluginContainer {
    name: "Maintenance"
    view: [
        {name: 'MaintenanceView', source: 'MaintenanceView', byDefault: true},
        {name: 'MaintenanceLightView', source: 'MaintenanceLightView'}
    ]
    model: "MaintenanceModel"
    singletonModel: true
}
