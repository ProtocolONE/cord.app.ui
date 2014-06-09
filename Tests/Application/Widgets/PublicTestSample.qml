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
import "../../../Application/Core/Popup.js" as PopupJs
import "../../../Application/Core/MessageBox.js" as MessageBoxJs

Rectangle {
    width: 1000
    height: 599
    color: '#EEEEEE'

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.AlertAdapter');
            manager.registerWidget('Application.Widgets.PublicTest');
            manager.init();

            PopupJs.init(popupLayer);
            MessageBoxJs.init(messageboxLayer);
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Assets/Images/test/main_07.png'
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

    //  Пример иконки PTS - поэтому открываем попуп не напрямую, а через сигнал
    Button {
        x: 450
        y: 450
        width: 300
        height: 30

        text: "Не хочу тестировать!"
        onClicked: AppJs.publicTestIconClicked();
    }

    Connections {
        target: AppJs.signalBus()

        onPublicTestIconClicked: {
            PopupJs.show("PublicTest");
        }
    }
}
