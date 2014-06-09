import QtQuick 1.1
import GameNet.Controls 1.0
import "../../Core/App.js" as App

Rectangle {

    color: 'white'

    Component.onCompleted:  progressTimer.start();

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

            interval: 35
            repeat: true

            onTriggered: {
                if (++progressBar.progress > 100) {
                    App.setGlobalState('Application')
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
