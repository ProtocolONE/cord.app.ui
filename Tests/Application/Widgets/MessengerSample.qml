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
import "../../../Application/Widgets/Messenger/Models/Messenger.js" as MessengerJs

Rectangle {
    width: 1000
    height: 800
    color: '#EEEEEE'

    Component.onCompleted: {

        var server = "qj.gamenet.ru"

//        var user = "400001000129602790";
//        var password = 'cbd12cfdbd30486a50e75073fcaee4f3';//Qt.md5('4c2f65777d38eb07d32d111061005dcd5a119150'); //"eb00b085998bb967ef7c2cb15d4475d6"

        var user = "400001000000073060"
        var password = Qt.md5('75517c5137f42a35f10cc984d8307209dd63b432')

//        var user = "400001000000065690"
//        var password = Qt.md5('cd34fe488b93d254243fa2754e86df8ffbe382b9')

        var bareJid = user + "@" + server;

        MessengerJs.connect(bareJid, password);
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
