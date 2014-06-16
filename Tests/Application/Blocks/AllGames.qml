import QtQuick 1.1
import "../../Application/Blocks" as Blocks

Item {
    width: 800
    height: 550
    visible: false

    Main {
        id: main

        anchors.fill: parent
        Component.onCompleted: parent.visible = true;
    }
}
