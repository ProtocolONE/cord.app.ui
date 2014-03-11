import QtQuick 1.1
import Tulip 1.0

Rectangle {
    id: root

    function start() {
        anim1.start();
    }

    color: "#000000"
    opacity: 0

    SequentialAnimation {
        id: anim1

        alwaysRunToEnd: true

        PropertyAnimation {
            alwaysRunToEnd: true
            target: root
            to: 0.99
            properties: "opacity"
            duration: 10
        }

        PropertyAnimation {
            alwaysRunToEnd: true
            from: 0.99
            to: 0
            properties: "opacity"
            easing.type: Easing.InBounce
            duration: 500
            target: root
        }
    }
}
