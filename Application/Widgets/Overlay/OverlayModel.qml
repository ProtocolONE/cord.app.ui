import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0

import "../../../Application/Core/App.js" as App
import "./Core/Popup.js" as TrayPopup

WidgetModel {
    id: root

    settings: WidgetSettings {
        namespace: 'Overlay'

        property string messengerOpenChatHotkey: JSON.stringify({key: Qt.Key_Backtab, name: "Shift + Tab"})
        property bool messengerShowChatOverlayNotify: true
    }

    width: 800
    height: 800

    Connections {
        target: App.signalBus()

        onServiceStarted: {
            d.createOverlay(gameItem.serviceId);
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
                // 26.08.2013 HACK Выключено из-за проблемы на XP
                '300002010000000000': 'View/Games/Aika.qml',
                '300003010000000000': 'View/Games/BS.qml',
                '300012010000000000': 'View/Games/Reborn.qml',
                '300009010000000000': 'View/Games/CA.qml'
            }

            if (!supportedGames.hasOwnProperty(service)) {
                return;
            }

            TrayPopup.clearAll();

            function finishCreation() {
                if (component.status === Component.Ready) {
                    var signalBusInstance = App.signalBus();

                    var overlayInstance = component.createObject(root,
                                                                 {
                                                                     width: 1024,
                                                                     height: 1024,
                                                                     x: -20000,
                                                                     y: -20000
                                                                 });
                    overlayInstance.init();
                    overlayInstance.forceActiveFocus();
                    App.setOverlayEnabled(true);

                    var serviceFinishCallback = function(gameItem) {
                        if (service == gameItem.serviceId) {
                            signalBusInstance.serviceFinished.disconnect(serviceFinishCallback);
                            overlayInstance.destroy();
                            App.setOverlayEnabled(false);
                        }
                    }

                    signalBusInstance.serviceFinished.connect(serviceFinishCallback);

                    overlayInstance.beforeClosed.connect(function() {
                        overlayInstance.destroy();
                        App.setOverlayEnabled(false);
                    });
                } else if (component.status === Component.Error) {
                    console.log("Error loading Overlay component:", component.errorString());
                    App.setOverlayEnabled(false);
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

