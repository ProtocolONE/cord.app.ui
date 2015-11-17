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
import Tulip 1.0

import Application 1.0
import Dev 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.MessageBox 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('sand');
        Popup.init(popupLayer);
        Tooltip.init(tooltipLayer);
        MessageBox.init(messageboxLayer);
    }

//    RequestServices {
//        onReady: {
//            var serviceItem = App.serviceItemByGameId("71");
//            serviceItem.statusText = "Sample text";

//            App.activateGame(serviceItem);
//        }
//    }

    Item {
        id: manager

        Component.onCompleted: {
            WidgetManager.registerWidget('Application.Widgets.ApplicationSettings');
            WidgetManager.registerWidget('Application.Widgets.AlertAdapter');
            WidgetManager.init();
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            console.log("Closed popupId: " + popupId);
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Button {
            x: 10
            y: 98
            width: 160
            height: 36
            text: 'Настройки Приложения'
            onClicked: Popup.show('ApplicationSettings');
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageboxLayer

        anchors.fill: parent
        z: 3
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
        z: 4
    }

//    Bootstrap {
//        anchors.fill: parent
//    }
}
