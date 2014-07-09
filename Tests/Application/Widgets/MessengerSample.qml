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

import "../../../Application/Core/App.js" as App
import "../../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs

Rectangle {
    width: 1000
    height: 800
    color: '#EEEEEE'

    Row {
        spacing: 10
        Button {
            width: 100
            height: 30
            text: 'Login'
            onClicked: App.authDone('400001000000073060', '75517c5137f42a35f10cc984d8307209dd63b432');
        }

        Button {
            width: 100
            height: 30
            text: 'Logout'
            onClicked: App.logoutDone();
        }

        Button {
            width: 100
            height: 30
            text: 'Disconnect'
            onClicked: MessengerJs.disconnect();
        }
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Messenger');
            manager.init();
        }
    }

    Row {
        anchors.fill: parent

        Item {
            height: parent.height
            width: 180
        }

        WidgetContainer {
            height: parent.height
            width: 590
            widget: 'Messenger'
            view: 'Chat'
        }

        Column {
            width: 230
            height: parent.height

            Rectangle {
                width: parent.width
                height: 91
                color: "#243148"
            }

            WidgetContainer {
                height: parent.height - 91
                width: 230
                widget: 'Messenger'
                view: 'Contacts'
            }
        }
    }
}
