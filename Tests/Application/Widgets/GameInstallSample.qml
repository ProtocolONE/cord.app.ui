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
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../js/Core.js" as CoreJs

Rectangle {
    width: 1000
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameInstall');
            manager.init();
            CoreJs.activateGame(CoreJs.serviceItemByGameId("92"));
        }
    }

    WidgetContainer {
        x: 182
        y: 115
        width: 629
        height: 375
        widget: 'GameInstall'
    }
}
