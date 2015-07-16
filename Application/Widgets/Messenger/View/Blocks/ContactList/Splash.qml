import QtQuick 2.4

import GameNet.Controls 1.0

import Application.Controls 1.0
import Application.Core.Styles 1.0

Item {
    id: root

    property string text
    property int waitTopMargin: 160

    ContentBackground {
        anchors.fill: parent
    }

    Wait {
        id: waitImage

        anchors {
            top: parent.top
            topMargin: root.waitTopMargin
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        color: Styles.textBase
        text: root.text
        font.pixelSize: 14

        anchors {
            top: waitImage.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
    }

    CursorMouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursor: Qt.ArrowCursor
    }
}
