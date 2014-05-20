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
    width: 1000 + 200
    height: 800
    color: '#EEEEEE'


    Component.onCompleted: {
        var user = "400001000001634860";
        var server = "j.gamenet.dev"
        var password = "4c2f65777d38eb07d32d111061005dcd5a119150"

        var bareJid = user + "@" + server;

        MessengerJs.connect(user, password);
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
        layoutDirection: Qt.RightToLeft

        Column {
            width: 228
            height: parent.height

            Rectangle {
                width: parent.width
                height: 90
                color: "#243148"
            }

            HorizontalSplit {
                width: parent.width
            }

            WidgetContainer {
                height: parent.height - 92
                width: 228
                widget: 'Messenger'
                view: 'Contacts'
            }
        }

        VerticalSplit {
            height: parent.height

            style: SplitterStyleColors {
                main: "#FFFFFF"
                shadow: "#E5E5E5"
            }
        }

        WidgetContainer {
            height: parent.height
            width: 590
            widget: 'Messenger'
            view: 'Chat'
        }

        VerticalSplit {
            height: parent.height

            style: SplitterStyleColors {
                main: "#FFFFFF"
                shadow: "#E5E5E5"
            }
        }
        Column {
            width: 228
            height: parent.height

            Rectangle {
                width: parent.width
                height: 90
                color: "#243148"
            }

            HorizontalSplit {
                width: parent.width
            }

            WidgetContainer {
                height: parent.height - 92
                width: 228
                widget: 'Messenger'
                view: 'Contacts'
            }
        }
    }


}
