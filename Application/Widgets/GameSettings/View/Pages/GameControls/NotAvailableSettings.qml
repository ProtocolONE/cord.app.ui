import QtQuick 2.4

import Application.Core.Styles 1.0

Item {
    id: settingsPageRoot

    function save() {
    }

    function load() {
    }

    Text {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 20
        }

        text: qsTr("Настройки игры будут доступны после установки.")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: Styles.infoText
        font { family: "Arial"; pixelSize: 14 }
    }
}
