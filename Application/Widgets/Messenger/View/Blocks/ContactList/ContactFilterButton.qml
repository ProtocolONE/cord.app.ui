import QtQuick 2.4
import ProtocolOne.Controls 1.0

import Application.Core.Styles 1.0

Button {
    id: allButton

    width: (root.width - 1) / 2
    height: parent.height

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    textColor: enabled ? Styles.chatInactiveText : Styles.menuText
    fontSize: 12

    Behavior on textColor {
        PropertyAnimation { duration: 250 }
    }

    Rectangle {
        visible: parent.enabled
        anchors.fill: parent
        color: parent.containsMouse ? Styles.dark : Styles.contentBackgroundLight
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
