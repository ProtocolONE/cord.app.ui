
import QtQuick 1.0
import "../Blocks" as Blocks
import "../js/Core.js" as Core

Blocks.SettingsPage {
    signal testAndCloseSignal();

    width: Core.clientWidth
    height: Core.clientHeight
}
