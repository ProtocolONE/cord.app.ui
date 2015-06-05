import QtQuick 1.1
import GameNet.Controls 1.0

import "../../../../../Core/Styles.js" as Styles

Button {
    id: allButton

    width: (root.width - 1) / 2
    height: parent.height

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    textColor: enabled ? Styles.style.chatInactiveText : Styles.style.menuText
    fontSize: 12

    Behavior on textColor {
        PropertyAnimation { duration: 250 }
    }

    Rectangle {
        visible: parent.enabled
        anchors.fill: parent
        color: parent.containsMouse ? Styles.style.dark : Styles.style.contentBackgroundLight
        opacity: parent.containsMouse ? 0.15 : 0.3
        radius: 1

        Behavior on color {
            PropertyAnimation { duration: 250 }
        }
        Behavior on opacity {
            PropertyAnimation { duration: 250 }
        }
    }
}
