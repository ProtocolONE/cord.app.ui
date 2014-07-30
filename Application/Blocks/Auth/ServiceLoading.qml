import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles

Rectangle {
    id: root

    signal finished();

    function startTimer() {
        progressTimer.start();
    }

    color: Styles.style.base

    AnimatedImage {
        anchors.centerIn: parent
        source: installPath + "/Assets/Images/Auth/wait.gif"
    }

    Timer {
        id: progressTimer

        interval: 1000
        repeat: false

        onTriggered: root.finished();
    }
}
