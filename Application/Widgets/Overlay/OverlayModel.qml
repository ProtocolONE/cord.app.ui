import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
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
        target: SignalBus

        onServiceStarted: {
            d.createOverlay(gameItem.serviceId);
        }
    }

    QtObject {
        id: d

        function createOverlay(service) {
            var overlayEnabled = App.serviceItemByServiceId(service).hasOverlay &&
                                 App.gameSettingsModelInstance().isOverlayEnabled(service);

            if (!overlayEnabled) {
                console.log('Overlay disabled for game ', service);
                return;
            }

            var component = null;
            var supportedGames = {
            }

            if (!supportedGames.hasOwnProperty(service)) {
                return;
            }

            TrayPopup.clearAll();

            function finishCreation() {
                if (component.status === Component.Ready) {
                    var overlayInstance = component.createObject(root,
                                                                 {
                                                                     width: 1024,
                                                                     height: 1024
                                                                 });
                    overlayInstance.init();
                    overlayInstance.forceActiveFocus();
                    App.setOverlayEnabled(true);

                    var serviceFinishCallback = function(gameItem) {
                        if (service == gameItem.serviceId) {
                            SignalBus.serviceFinished.disconnect(serviceFinishCallback);
                            overlayInstance.destroy();
                            App.setOverlayEnabled(false);
                        }
                    }

                    SignalBus.serviceFinished.connect(serviceFinishCallback);

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

