import QtQuick 2.4
import ProtocolOne.Components.Widgets 1.0

PluginContainer {
    name: "UserProfile"
    view: [
        {name: 'UserProfileView', source: 'UserProfileView', byDefault: true},
        {name: 'PromoActionIconView', source: 'PromoActionIconView'}
    ]

    model: "UserProfileModel"
    singletonModel: true
}
