import QtQuick 1.1

Item {
    Rectangle {
        anchors.fill: parent
        color: "#bdbdbd"
        opacity: Qt.application.active ? 0 : 0.15

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
