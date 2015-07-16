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
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Core.Popup 1.0

import Dev 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    // Initialization

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('sand');
        Popup.init(popupLayer);
    }

    RequestServices {
        onReady: {
            App.activateGame(App.serviceItemByGameId("92"));
            RestApi.Core.setUserId("400001000092302250");
            RestApi.Core.setAppKey("86c558d41c1ae4eafc88b529e12650b884d674f5");
            manager.registerWidget('Application.Widgets.PromoCode');
            manager.init();
        }
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {

        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Rectangle {
            x: 840
            y: 55
            width: 150
            height: 20
            color: "#FF0000"

            Text {
                text: "Тыц!"
                anchors.centerIn: parent
            }
        }

        MouseArea {
            x: 840
            y: 55
            width: 150
            height: 20

            onClicked: Popup.show("PromoCode");
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
