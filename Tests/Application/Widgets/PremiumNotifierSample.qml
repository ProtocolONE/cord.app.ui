/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../Application/Core/App.js" as AppJs

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.PremiumNotifier');
            manager.init();

            emulateTimer.start();
        }
    }

	Timer {
        id: emulateTimer

        interval: 2000
        repeat: false
        onTriggered: {
            AppJs.premiumExpired();
        }
	}

    Connections {
        target: AppJs.signalBus();

        onProlongPremium: {
            console.log("Prolong premium clicked!");
        }
    }
}
