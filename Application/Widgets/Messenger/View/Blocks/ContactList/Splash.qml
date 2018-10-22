import QtQuick 1.1
import Tulip 1.0
import GameNet.Controls 1.0

import "../../../../../Core/Styles.js" as Styles

Item {
    id: root

    property string text
    property int waitTopMargin: 160

    Rectangle {
        anchors.fill: parent
        color: Styles.style.contentBackgroundLight
        opacity: Styles.style.baseBackgroundOpacity
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
        color: Qt.darker(Styles.style.messengerSplashStatus, Styles.style.darkerFactor)
        text: root.text
        font {
            pixelSize: 14
        }
        anchors {
            top: waitImage.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
    }

    CursorMouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursor: CursorArea.ArrowCursor
    }
}
