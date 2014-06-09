///****************************************************************************
//** This file is a part of Syncopate Limited GameNet Application or it parts.
//**
//** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
//** All rights reserved.
//**
//** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
//** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Application/Core/App.js" as App

Rectangle {
    width: 800
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            var serviceId = App.serviceItemByGameId("71").serviceId;

            manager.registerWidget('Application.Widgets.Money');
            manager.registerWidget('Application.Widgets.Overlay');
            manager.init();

            App.setSettingsValue('gameExecutor/serviceInfo/' + serviceId + "/",
                                 "overlayEnabled", 1);

            App.isPublicVersion = function() {
                return true;
            }

            initOverlayTimer.start();
        }
    }

    Timer {
        id: initOverlayTimer

        interval: 3000
        repeat: false
        onTriggered: {
            App.serviceStarted(App.serviceItemByGameId("71"));
            App.navigate("gogamenetmoney");
        }
    }
}
