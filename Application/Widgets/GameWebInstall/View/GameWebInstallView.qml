import QtQuick 2.4

import ProtocolOne.Controls 1.0

import Application.Blocks 1.0
import Application.Blocks.Popup 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0

PopupBase {
    id: root

    property variant currentGame
    property alias createDesktopShortcut: desktopShortcut.checked
    property alias createStartMenuShortcut: startMenuShortcut.checked
    property variant gameSettingsModelInstance: App.gameSettingsModelInstance()

    Component.onCompleted: {
        root.currentGame = App.currentGame();
        root.gameSettingsModelInstance.switchGame(root.currentGame.serviceId);
    }

    title: qsTr("INSTALL_VIEW_TITLE").arg(currentGame.name)
    height: 247
    clip: true

    CheckBox {
        id: desktopShortcut

        width: 300
        fontSize: 15
        checked: false
        text: qsTr("CREATE_DESKTOP_SHORTCUT")
    }

    CheckBox {
        id: startMenuShortcut

        width: 300
        fontSize: 15
        checked: false
        text: qsTr("CREATE_STARTMENU_SHORTCUT")
    }

    PopupHorizontalSplit {}

    PrimaryButton {
        id: installButton

        ShakeAnimation {
            id: shakeAnimation

            target: installButton
            property: "anchors.leftMargin"
            from: 0
            shakeValue: 2
            shakeTime: 120
        }

        Timer {
            id: shakeAnimationTimer

            interval: 5000
            running: root.visible
            onTriggered: shakeAnimation.start();
        }

        width: 200
        height: 48
        analytics {
            category: 'GameInstall'
            action: 'play'
            label: root.currentGame.gaName
        }
        anchors {
            left: parent.left
            leftMargin: 0
        }
        text: qsTr("RUN_BUTTON_CAPTION")
        onClicked: {
            if (desktopShortcut.checked) {
                gameSettingsModelInstance.createShortcutOnDesktop(currentGame.serviceId);
            }

            if (startMenuShortcut.checked) {
                gameSettingsModelInstance.createShortcutInMainMenu(currentGame.serviceId);
            }

            App.executeService(currentGame.serviceId);
            root.close();
        }
    }
}
