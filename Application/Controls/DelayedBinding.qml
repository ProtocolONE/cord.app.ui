import QtQuick 1.1

Item {
    id: root

    property alias target: binding.target
    property alias property: binding.property
    property alias value: binding.value

    signal bind();

    Component.onCompleted: delayTimer.start()

    Binding {
        id: binding
    }

    Timer {
        id: delayTimer

        interval: 10
        running: false
        repeat: false
        onTriggered: root.bind();
    }

}
