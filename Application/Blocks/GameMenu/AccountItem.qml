import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles

Item {
    id: root

    property bool activated: false

    implicitHeight: 61
    implicitWidth: 100

    signal clicked();

    function closePanel() {
        root.activated = false;
    }

    AccountItemBottom {
        visible: root.activated
        color: Styles.style.contentBackgroundLight
    }

    GameMenuItem {
        y: 1
        anchors {left: parent.left; right: parent.right; leftMargin: 1; rightMargin: 1}
        text: qsTr("GAME_MENU_SPECIAL_BUTTON_ACCOUNTS")
        icon: installPath + Styles.style.gameMenuExtendedAccIcon
        activeOpacity: activated ? 0 : 0.3
        onClicked: root.activated = !root.activated;
    }

    ContentStroke {
        visible: !root.activated
        width: parent.width
    }

    AccountItemTop {
        visible: root.activated
    }
}
