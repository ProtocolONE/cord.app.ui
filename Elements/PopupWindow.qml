// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Tulip 1.0
import "../js/PopupHelper.js" as PopupHelper

Window {
    property int spacing: 5
    x: Desktop.primaryScreenAvailableGeometry.width - width + Desktop.primaryScreenAvailableGeometry.x - spacing
    y: Desktop.primaryScreenAvailableGeometry.height - height + Desktop.primaryScreenAvailableGeometry.y - spacing

    flags: Qt.Window | Qt.FramelessWindowHint | Qt.Tool | Qt.WindowMinimizeButtonHint
           | Qt.WindowMaximizeButtonHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

    width: popupColumn.width
    height: 800
    deleteOnClose: false
    visible: popupColumn.children.length > 0
    topMost: true

    Item {
        anchors.fill: parent

        Column {
            id: popupColumn
            anchors.top: parent.bottom
            width: 211
            spacing: 10
            transform: Rotation { angle: 180 }

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Component.onCompleted: PopupHelper.initialize(popupColumn);
}
