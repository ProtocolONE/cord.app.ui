import QtQuick 2.4

QtObject {
    id: fakeGameSettingsModelInstance

    property bool hasDownloadPath: true
    property string installPath: "C:\\Program Files (x86)\\QGNA\\Games"
    property string downloadPath: "C:\\Program Files (x86)\\QGNA\\Downloads"

    function switchGame(serviceId) {
    }

    function createShortcutOnDesktop(serviceId) {
        console.log('[GameSettings] createShortcutOnDesktop', serviceId)
    }

    function createShortcutInMainMenu(serviceId) {
        console.log('[GameSettings] createShortcutInMainMenu', serviceId)
    }

    function isOverlayEnabled(serviceId) {
        return true;
    }

    function restoreClient()  {

    }
}
