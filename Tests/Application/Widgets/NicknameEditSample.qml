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
import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/restapi.js" as RestApiJs

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    // Initialization

    Component.onCompleted: {
        Settings.setValue("qml/core/popup/", "isHelpShowed", 0);
        Popup.init(popupLayer);
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            RestApiJs.Core.setUserId("400001000092302250");
            RestApiJs.Core.setAppKey("86c558d41c1ae4eafc88b529e12650b884d674f5");

            manager.registerWidget('Application.Widgets.NicknameEdit');
            manager.init();
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Assets/Images/test/main_07.png'
        }

        MouseArea {
            x: 840
            y: 55
            width: 150
            height: 20

            onClicked: Popup.show("NicknameEdit");
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
