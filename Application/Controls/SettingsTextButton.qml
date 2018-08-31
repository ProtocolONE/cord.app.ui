import QtQuick 2.4
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

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
        color: Styles.contentBackgroundLight
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
        color: root.checked ? Styles.lightText : Styles.infoText
    }
}

