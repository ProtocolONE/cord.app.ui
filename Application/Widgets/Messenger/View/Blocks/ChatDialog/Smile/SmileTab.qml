import QtQuick 1.1

import GameNet.Controls 1.0

import "../../../../../../Core/Styles.js" as Styles

Rectangle {
    id: root

    signal clicked();

    property string tultip
    property string imageSource
    property bool isActive: false

    color: mouseArea.containsMouse || root.isActive ?
               Styles.style.messengerSmilePanelHover : '#00000000'

    Image {
        anchors.centerIn: parent
        source: root.imageSource ? installPath + root.imageSource : ''
    }

    CursorMouseArea {
        id: mouseArea

        toolTip: root.tultip
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked();
    }

    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: Styles.style.messengerSmilePanelBorder
        visible: mouseArea.containsMouse || root.isActive
    }

    Rectangle {
        anchors.left: parent.left
        width: 1
        height: parent.height
        color: Styles.style.messengerSmilePanelBorder
        visible: mouseArea.containsMouse || root.isActive
    }
}
