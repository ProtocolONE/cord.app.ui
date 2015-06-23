import QtQuick 1.1
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../Core/Styles.js" as Styles


Button {
    id: root

    property bool checked: false
    property alias text: textItem.text

    implicitWidth: parent.width
    implicitHeight: 53

    style {
        normal: "#00000000"
        hover: "#00000000"
        disabled: "#00000000"
    }

    Rectangle {
        anchors.fill: parent
        color: Styles.style.contentBackgroundLight
        opacity: 0.15
        visible: root.checked
    }

    ContentStroke {
        anchors.fill: parent
        visible: root.containsMouse
    }

    Text {
        id: textItem

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 44
        }

        font { family: "Open Sans Regular"; pixelSize: 15 }
        color: root.checked ? Styles.style.lightText : Styles.style.infoText
    }
}

