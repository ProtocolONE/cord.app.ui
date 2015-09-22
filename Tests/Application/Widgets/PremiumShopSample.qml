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

import Application.Core.MessageBox 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    RequestServices {
        onReady: {
            WidgetManager.registerWidget('Application.Widgets.PremiumShop');
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
            WidgetManager.init();

            MessageBox.init(messageBoxLayer);
        }
    }

    WidgetContainer {
        x: 182
        y: 115
        width: 630
        height: 375
        widget: 'PremiumShop'
    }

    Item {
        id: messageBoxLayer

        anchors.fill: parent
    }

}
