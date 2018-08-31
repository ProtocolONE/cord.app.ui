import QtQuick 2.4

import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

WidgetView {
    id: root

    property bool isPromoActionActive: model.isPromoActionActive
    property int animationDuration: 4000

    implicitHeight: 2
    implicitWidth: 2

    Rectangle {
        id: rect

        anchors.centerIn: parent
        width: 20
        height: width
        radius: width/2
        color: "#EEAA00"
        clip: true

        ParallelAnimation {
            running: root.visible
            loops: Animation.Infinite

            SequentialAnimation {
                ColorAnimation { target: rect; property: "color"; to: "#464E56"; duration: animationDuration }
                ColorAnimation { target: rect; property: "color"; to: "#EEAA00"; duration: animationDuration }
            }

            SequentialAnimation {
                NumberAnimation {
                    target: rect
                    property: "width"
                    duration: animationDuration
                    to: 10
                    easing.type: Easing.InOutBack
                }

                NumberAnimation {
                    target: rect
                    property: "width"
                    duration: animationDuration
                    to: 20
                    easing.type: Easing.InOutBack
                }
            }
        }
    }
}
