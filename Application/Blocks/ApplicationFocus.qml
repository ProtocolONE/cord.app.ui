import QtQuick 2.4
import Application.Core 1.0
import Application.Core.Styles 1.0

Item {
    Rectangle {
        anchors.fill: parent

        color: Styles.focusOverlay
        opacity: Qt.application.active ? 0 : Styles.focusOverlayOpacity

        Behavior on opacity {
            PropertyAnimation { duration: 75 }
        }

        MouseArea {
            visible: parent.opacity > 0
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
        }
    }

    Image {
        anchors{ left: parent.left; bottom: parent.bottom; margins: 10 }
        source: installPath + "Assets/Images/Application/Blocks/ApplicationFocus/lock.png"
        opacity: Qt.application.active ? 0 : 0.75
        visible: opacity > 0

        Behavior on opacity {
            PropertyAnimation { duration: 75 }
        }
    }
}
