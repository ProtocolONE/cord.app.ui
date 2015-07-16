import QtQuick 2.4

import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    signal clicked();

    property string tultip
    property string imageSource
    property bool isActive: false

    property bool isFirst: false
    property bool isLast: false

    Rectangle {
        anchors {
            fill: parent
            margins: 1
        }
        color: Styles.dark
        opacity: 0.2
        visible: root.isActive
    }

    Rectangle {
        anchors {
            fill: parent
            topMargin: 1
            bottomMargin: 1
        }
        color: Styles.light
        opacity: 0.1
        visible: mouseArea.containsMouse
    }

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

    ContentStroke {
        height: parent.height - 2
        y: 1
        visible: (root.isActive) && !root.isFirst
    }

    ContentStroke {
        anchors.right: parent.right
        height: parent.height - 2
        y: 1
        visible: (root.isActive) && !root.isLast
    }
}
