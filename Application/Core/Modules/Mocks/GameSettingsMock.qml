import QtQuick 2.4

QtObject {
    id: fakeGameSettingsModelInstance

    property bool hasDownloadPath: true

    property string installPath: "D:/Games/BattleCarnival"
    property string downloadPath: "D:/Games/BattleCarnival"

    //property string installPath: "C:\\Program Files (x86)\\ProtocolOne\\Launcher\\Games"
    //property string downloadPath: "C:\\Program Files (x86)\\ProtocolOne\\Launcher\\Downloads"

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

    function restoreClient() {
        console.log('[GameSettings] restoreClient')
    }

    function setOverlayEnabled(serviceId, value) {
        console.log('[GameSettings] setOverlayEnabled', serviceId, value)
    }

    function submitSettings() {
           console.log('[GameSettings] submitSettings')
    }

    function isPrefer32Bit(serviceId) {
        return true;
    }

    function setPrefer32Bit(serviceId, value) {
        console.log('[GameSettings] setPrefer32Bit', serviceId, value)
    }

    function browseInstallPath(qwe) {
        installPath = "D:\\Games\\Привет _ BattleCarnival";
    }

}
