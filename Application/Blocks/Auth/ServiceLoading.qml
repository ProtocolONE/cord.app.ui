import QtQuick 1.1
import GameNet.Controls 1.0
import "../../Core/App.js" as App

Rectangle {
    id: root

    signal finished();

    color: "#FAFAFA"

    onVisibleChanged: if (visible) progressTimer.start();

    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 150
        }

        text: 'Loading services...'
        color: '#111111'

        font { family: 'Arial'; pixelSize: 18 }

    }

    ProgressBar {
        id: progressBar

        Timer {
            id: progressTimer

            interval: 15
            repeat: true

            onTriggered: {
                if (++progressBar.progress > 100) {
                    root.finished();
                    progressTimer.stop();
                }
            }
        }

        width: parent.width - 30
        height: 10
        anchors.centerIn: parent
        progress: 0
        style: ProgressBarStyleColors {
            line: '#dddddd'
        }
        animated: true

    }
}
