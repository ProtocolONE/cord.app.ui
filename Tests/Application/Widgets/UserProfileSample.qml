/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Dev 1.0

import Application.Core 1.0

Rectangle {
    width: 1000
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.UserProfile');
            manager.init();

            SignalBus.authDone("400001000092302250", "86c558d41c1ae4eafc88b529e12650b884d674f5");
        }
    }

    WidgetContainer {
        x: 771
        y: 42
        width: 229
        height: 92
        widget: 'UserProfile'
    }
}
