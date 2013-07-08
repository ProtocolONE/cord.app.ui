import QtQuick 1.1
import Tulip 1.0

Item {
    id: root

    width: 800
    height: 800

    // HACK
    //Component.onCompleted: d.createOverlay("300003010000000000");

    Connections {
        target: mainWindow

        onServiceStarted: {
            d.createOverlay(service);
        }
    }

    QtObject {
        id: d

        function createOverlay(service) {
            var overlayEnabled = Settings.value(
                        'gameExecutor/serviceInfo/' + service + "/",
                        "overlayEnabled",
                        1) != 0;

            if (!overlayEnabled) {
                console.log('Overlay disabled for game ', service);
                return;
            }

            var component = null;
            var supportedGames = {
                '300002010000000000': 'Games/Aika.qml',
                '300003010000000000': 'Games/BS.qml',
            }

            if (!supportedGames.hasOwnProperty(service)) {
                return;
            }

            function finishCreation() {
                if (component.status === Component.Ready) {
                    var overlayInstance = component.createObject(root,
                                                                 {
                                                                     width: 1024,
                                                                     height: 1024,
                                                                     x: -20000,
                                                                     y: -20000
                                                                 });
                    overlayInstance.init();
                    overlayInstance.forceActiveFocus();

                    var serviceFinishCallback = function(serviceId) {
                        if (service == serviceId) {
                            mainWindow.serviceFinished.disconnect(serviceFinishCallback);
                            overlayInstance.destroy();
                        }
                    }

                    mainWindow.serviceFinished.connect(serviceFinishCallback);

                    overlayInstance.beforeClosed.connect(function() {
                        overlayInstance.destroy();
                    });
                } else if (component.status === Component.Error) {
                    console.log("Error loading Overlay component:", component.errorString());
                }
            }

            component = Qt.createComponent(supportedGames[service]);
            if (component.status === Component.Ready) {
                finishCreation();
            } else {
                component.statusChanged.connect(finishCreation);
            }
        }
    }
}

