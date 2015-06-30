import QtQuick 1.1

QtObject {
    id: fakeSettingsViewModelInstance

    // INFO Мок не сохраняет данные. Если необходимо, надо дописать сохранение в Settings

    property int downloadSpeed: 0
    property int uploadSpeed: 0
    property string incomingPort: "11888"
    property string numConnections: "200"
    property bool seedEnabled: true

    property int autoStart: 2

    function setAutoStart(value) {
        fakeSettingsViewModelInstance.autoStart = value;
    }
}
