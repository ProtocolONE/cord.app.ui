import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

WidgetModel {
    id: root

    settings: WidgetSettings {
        property string uuid;
        autoSave: ['uuid']
    }

    property string currentScreen;
    property int popupCount: 0;

    function trackAppScreen(name) {
        root.currentScreen = name;
        Ga.trackScreen(name);
    }

    Connections {
        target: SignalBus
        ignoreUnknownSignals: true

        onNavigate: {
            console.log("Navigate:", link, 'from', from);
            var screenName = '/' + link,
                game;

            if (link === 'mygame') {
                game = App.currentGame();
                screenName += '/' + game.gaName
            }

            trackAppScreen(screenName);
        }

        onSetGlobalState: {
            console.log('SetGlobalState', name);
            if (name === 'Authorization') {
                //INFO Фактический экран в состоянии `Application` определяется событиями навигации, а трекинг события
                //экрана загрузки нам не интересен.
                trackAppScreen(name);
            }
        }

        //onAuthDone: Ga.setUserId(userId);
        onLogoutDone: Ga.setUserId(false);
    }

    Connections {
        target: Popup
        ignoreUnknownSignals: true

        onOpen: {
            var name = '/' + widgetName + '/' + widgetView;

            root.popupCount++;
            Ga.trackScreen(name);

            console.log('Open Popup Window Id', popupId, name);
        }

        onClose: {
            root.popupCount--;
            if (root.popupCount === 0) {
                Ga.trackScreen(root.currentScreen);
            }

            console.log('Close Popup Window Id', popupId);
        }
    }
}
