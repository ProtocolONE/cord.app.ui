import QtQuick 2.4
import ProtocolOne.Controls 1.0

Rectangle {
    implicitWidth: shieldItemText.width + 10
    implicitHeight: 16
    color: "#FF4F02"

    Text {
        id: shieldItemText

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 5
        }

        color: "#F3DCA5"
        font {
            pixelSize: 12
            family: "Segoe UI"
            letterSpacing: -0.72
        }

        text: "ProtocolOne"
    }

    CursorMouseArea {
        anchors.fill: parent
        toolTip: qsTr("Сотрудник ProtocolOne")
        cursorShape: Qt.ArrowCursor
    }
}
