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
import Dev 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    Component.onCompleted:  {
        WidgetManager.registerWidget('Application.Widgets.PremiumServer');
        WidgetManager.init();
    }

    RequestServices {
        onReady: {
            var serviceItem = App.serviceItemByGameId("1021");
            App.activateGame(serviceItem);

            Popup.init(parent);
        }
    }

    Column {
        x: 10
        y: 10
        spacing: 10

        Button {
            text: "Продлить"
            onClicked: Popup.show('PremiumServer')
        }

        WidgetContainer {
            widget: "PremiumServer"
            view: "PremiumServerLineView"
        }
    }
}
