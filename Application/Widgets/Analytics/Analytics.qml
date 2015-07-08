/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0 as Controls

import "../../Core/App.js" as App
import "../../Core/Popup.js" as Popup

import "../../../GameNet/Core/Analytics.js" as Ga

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
        target: App.signalBus()
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

        onAuthDone: Ga.setUserId(userId);
        onLogoutDone: Ga.setUserId(false);
    }

    Connections {
        target: Popup.signalBus()
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
