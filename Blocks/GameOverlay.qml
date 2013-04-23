import QtQuick 1.1
import Tulip 1.0

Item {
    id: root

    // HACK
    // Component.onCompleted: d.createOverlay();

    Connections {
        target: mainWindow

        onServiceStarted: {
            console.log('Overlay game started');
            d.createOverlay();
        }

        onServiceFinished: {
            console.log('Overlay game finished');
            d.destroyOverlay();
        }
    }

    QtObject {
        id: d

        property variant overlayInstance

        function createOverlay() {
            var q = overlay.createObject(root,
                                         {
                                             width: 1024,
                                             height: 1024,
                                             x: -20000,
                                             y: -20000
                                         });
            q.init();
            d.overlayInstance = q;
        }

        function destroyOverlay() {
            if (d.overlayInstance) {
                d.overlayInstance.destroy();
                d.overlayInstance = 0;
            }
        }
    }



    Component {
        id: overlay

        Overlay {
            id: overlayInstance

            property variant self

            flags: Qt.Window | Qt.Tool | Qt.FramelessWindowHint

//            flags: Qt.Window | Qt.FramelessWindowHint | Qt.Tool | Qt.WindowMinimizeButtonHint
//                   | Qt.WindowMaximizeButtonHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

            width: 1024
            height: 1024
            x: 10
            y: 10
            visible: true
            captureKeyboard: true
            captureMouse: true
            drawFps: false
            opacity: 1

            onBeforeClosed: {
                console.log('Overlay before closed');
                d.destroyOverlay();
            }

            onGameInit: {
                console.log('Overlay game init', width, height);
                overlayInstance.width = width;
                overlayInstance.height = height;
            }

            Rectangle {
                anchors.fill: parent
                color: "#00000000"
                opacity: 1

                Rectangle {
                    width: 50
                    height: 50
                    color: "red"

                    anchors {
                        top: parent.top
                        topMargin: 25

                        right: parent.right
                        rightMargin: 25
                    }
                }
            }
        }

    }
}
