import QtQuick 1.1
import "../../Elements" as Elements

Item {
    property bool isTopButton: true

    signal enter()
    signal click()
    signal exit()

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }

    Image {
        anchors.verticalCenter: parent.verticalCenter
        source: installPath + "images/control.png"
        rotation: isTopButton ? 180 : 0

        Elements.CursorMouseArea {
            id: mouser

            anchors.fill: parent
            hoverEnabled: true
            onClicked: click()
            onEntered: enter()
            onExited: exit()
        }
    }

    Image {
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 54 }
        source: installPath + "images/controlarrow.png"
        opacity: mouser.containsMouse ? 1 : 0.8
        rotation: isTopButton ? 180 : 0
    }
}
