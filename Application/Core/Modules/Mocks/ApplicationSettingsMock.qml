import QtQuick 2.4

QtObject {
    id: fakeSettingsViewModelInstance

    // INFO Мок не сохраняет данные. Если необходимо, надо дописать сохранение в Settings

    property int downloadSpeed: 150
    property int uploadSpeed: 150
    property string incomingPort: "11888"
    property string numConnections: "200"
    property bool seedEnabled: true
    property int torrentProfile: 1

    property int autoStart: 2

    function setAutoStart(value) {
        fakeSettingsViewModelInstance.autoStart = value;
    }
}
