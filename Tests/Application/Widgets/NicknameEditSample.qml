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
import Dev 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

Rectangle {
    width: 1000
    height: 600
    color: '#AAAAAA'

    Component.onCompleted: {
        Styles.init();
        Styles.setCurrentStyle('sand');
        Popup.init(popupLayer);

        RestApi.Core.setUserId("400001000142709890");
        RestApi.Core.setAppKey("66a7e3447e6bef9b852a96c4d9ac800f226e4976");

        WidgetManager.registerWidget('Application.Widgets.NicknameEdit');
        WidgetManager.registerWidget('Application.Widgets.NicknameReminder');
        WidgetManager.init();
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

        MouseArea {
            x: 840
            y: 55
            width: 150
            height: 20

            onClicked: {
                console.log("Opened popupId: " + Popup.show('NicknameEdit'));
            }
        }
    }

    Button {
        x: 10
        y: 10
        text: 'NicknameReminder'
        onClicked: Popup.show('NicknameReminder');
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }
}
