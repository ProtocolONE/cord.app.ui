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

import "../../../Application/Core/App.js" as AppJs
import "../../../Application/Core/restapi.js" as RestApiJs

Rectangle {
    width: 1200
    height: 800
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Money');
            manager.init();

            AppJs.authDone("400001000092302250", "86c558d41c1ae4eafc88b529e12650b884d674f5");

            //  Мокаем нужные функции
            AppJs.isPublicVersion = function() {
                return false;
            }
            AppJs.isWindowVisible = function() {
                return true;
            }
            RestApiJs.Billing.isInGameRefillAvailable = function(fn) {
                fn({enabled: true})
            }

            runMoney.start();
        }
    }

    WidgetContainer {
        width: 590
        height: 400
        widget: 'Money'
    }

    Timer {
        id: runMoney

        repeat: false
        interval: 1000
        onTriggered: AppJs.navigate("gogamenetmoney");
    }
}
