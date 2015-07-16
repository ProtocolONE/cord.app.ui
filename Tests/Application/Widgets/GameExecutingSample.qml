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

import Tulip 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    // Initialization
    Component.onCompleted: {
        Popup.init(popupLayer);
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("92"));
        }
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameAdBanner');
            manager.registerWidget('Application.Widgets.GameInfo');
            manager.registerWidget('Application.Widgets.GameExecuting');
            manager.init();

            //  stub
            App.executeService = function(serviceId) {
                console.log("App::executeService() called: " + serviceId);
            }
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

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }


        Button {
            x: 10
            y: 98
            width: 160
            height: 36
            text: 'Начать игру'
            onClicked: Popup.show('GameExecuting');
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
