import QtQuick 1.1
import Tulip 1.0

import GameNet.Controls 1.0
import Application.Controls 1.0
import "../../../../../Core/Styles.js" as Styles

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
        color: Styles.style.dark
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
               ? Styles.style.menuText
               : Styles.style.chatInactiveText
        font {
            family: "Arial"
            pixelSize: 14
        }
    }

}
