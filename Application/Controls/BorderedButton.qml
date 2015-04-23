import QtQuick 1.1
import GameNet.Controls 1.0

Button {
    id: root

    property BorderedButtonStyle style: BorderedButtonStyle {}

    implicitWidth: 139
    implicitHeight: 31

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }
        color: "#00000000"
        border {
            width: 1
            color: root.containsMouse
                   ? root.style.hover
                   : root.style.border
        }
    }
}
