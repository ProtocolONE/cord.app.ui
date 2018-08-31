import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Controls 1.0
import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property bool selected: false
    property alias text: buttonText.text
    property alias textColor: buttonText.color

    signal clicked();

    width: 100
    height: 30

    Button {
        id: button

        anchors.fill: parent
        style {
            normal: "#00000000"
            hover: "#00000000"
            disabled: "#00000000"
        }

        enabled: !root.selected
        onClicked: root.clicked();
    }

    Rectangle {
        anchors.fill: parent
        color: Styles.dark
        opacity: button.containsMouse ? 0.15 : 0.3
        visible: !root.selected

        Behavior on opacity {
            NumberAnimation { duration: 250}
        }
    }

    Text {
        id: buttonText

        anchors.centerIn: parent
        color: root.selected
               ? Styles.menuText
               : Styles.chatInactiveText
        font {
            family: "Arial"
            pixelSize: 14
        }
    }

}
