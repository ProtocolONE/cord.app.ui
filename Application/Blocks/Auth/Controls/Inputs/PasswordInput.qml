import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    default property alias someName: root.data

    property alias placeholder: control.placeholder
    property alias text: control.text
    property alias error: control.error
    property alias errorMessage: errorContainer.errorMessage

    signal tabPressed()
    signal backTabPressed()

    height: 64
    implicitWidth: parent.width

    onFocusChanged: {
        if (focus) {
            control.focus = true
        }
    }

    Column {
        anchors.fill: parent

        Input {
            id: control

            language: App.keyboardLayout()
            capsLock: App.isCapsLockEnabled()
            passwordType: true

            height: 48
            width: parent.width
            maximumLength: 32

            onTabPressed: root.tabPressed();
            onBackTabPressed: root.backTabPressed();
            icon: installPath + Styles.inputPasswordIcon
        }

        ErrorContainer {
            id: errorContainer

            error: root.error
            width: parent.width
            height: 16
        }
    }
}
