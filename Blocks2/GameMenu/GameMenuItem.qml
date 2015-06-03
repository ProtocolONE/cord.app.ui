import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0
import Application.Controls 1.0

import "../../Core/Styles.js" as Styles

Item {
    id: root

    property alias text: caption.text
    property string icon
    property bool current: false

    property alias activeColor: background.color
    property alias activeOpacity: background.opacity
    property alias backgroundVisible: background.visible
    property bool strokeVisibility

    implicitHeight: 60
    implicitWidth: 100

    signal clicked();

    Rectangle {
        id: background

        anchors.fill: parent
        color: Styles.style.dark
        opacity: 0.3
        visible: !root.current
    }

    Image {
        source: mouser.containsMouse || root.current
            ? root.icon.replace('.png', '_hover.png')
            : root.icon

        anchors {horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 30}
    }

    Text {
        id: caption

        color: mouser.containsMouse || root.current
               ? Styles.style.lightText
               : Qt.darker(Styles.style.lightText, 1.25)

        font { family: "Arial"; pixelSize: 14 }
        anchors {horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 12}
    }

    CursorMouseArea {
        id: mouser

        visible: !root.current
        anchors.fill: parent
        onClicked: root.clicked();
    }
}
