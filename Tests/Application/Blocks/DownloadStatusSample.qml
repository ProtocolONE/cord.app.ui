import QtQuick 1.1
import Application.Blocks 1.0

Rectangle {
    width: 800
    height: 800
    color: '#111111'


    DownloadStatus {
        width: 75
        anchors.centerIn: parent
        serviceItem: Item {
            property string statusText
            property int progress: 50

            Timer {
                running: true
                interval: 1000
                repeat: true
                triggeredOnStart: true
                onTriggered: parent.statusText = 'Download long text with ' + (1000000 * Math.random() |0)
            }
        }
    }
}
