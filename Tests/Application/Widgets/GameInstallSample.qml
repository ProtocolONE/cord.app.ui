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
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 800
    color: '#EEEEEE'

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("1073"));
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
            WidgetManager.registerWidget('Application.Widgets.GameInstall');
            WidgetManager.init();

            MessageBox.init(messageLayer);
            Popup.init(popupLayer);

        }
    }

//    WidgetContainer {
//        x: 182
//        y: 115
//        width: 629
//        height: 375
//        widget: 'GameInstall'
//    }

    Row {
        x: 50
        y: 50

        spacing: 20

        Button {
            text: "Show"
            onClicked: App.mainWindowInstance().showLicense("370000000000")
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
    }

    Item {
        id: messageLayer

        anchors.fill: parent
    }
}
