///****************************************************************************
//** This file is a part of Syncopate Limited GameNet Application or it parts.
//**
//** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
//** All rights reserved.
//**
//** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
//** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//****************************************************************************/
import QtQuick 2.4
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Controls 1.0

import "../../../../Application/Core/App.js" as App
import "../"

Rectangle {
    id: root

    width: 800
    height: 800
    color: '#EEEEEE'

    RequestServices {
        onReady: {
            App.setSettingsValue('gameExecutor/serviceInfo/' + serviceId + "/",
                                 "overlayEnabled", 1);

            var serviceId = App.serviceItemByGameId("71").serviceId;
            initOverlayTimer.start();
        }
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            Shell.execute(installPath + "Tests/Application/Widgets/Overlay/Tools/NormalWayIntegration.exe", ["-width", "1920", "-height", "1080"]);

            manager.registerWidget('Application.Widgets.UserProfile');
            manager.registerWidget('Application.Widgets.Messenger');
            manager.registerWidget('Application.Widgets.DetailedUserInfo');
            manager.registerWidget('Application.Widgets.AlertAdapter');

            manager.registerWidget('Application.Widgets.Money');
            manager.registerWidget('Application.Widgets.Overlay');
            manager.init();

            App.isPublicVersion = function() {
                return true;
            }
        }
    }

    Timer {
        id: initOverlayTimer

        interval: 3000
        repeat: false
        onTriggered: {
            SignalBus.serviceStarted(App.serviceItemByGameId("71"));
            //SignalBus.navigate("gogamenetmoney", '');
        }
    }
}
