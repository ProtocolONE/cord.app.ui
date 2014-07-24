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

import "../Models/Messenger.js" as MessengerJs

WidgetView {
    implicitWidth: parent.width
    implicitHeight: parent.height

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 1
        }

        color: "#EEEEEE"

        PlainContacts {
            anchors.fill: parent
        }

        AnimatedImage {
            anchors.centerIn: parent
            visible: MessengerJs.isConnecting()
            source: installPath + "Assets/Images/Application/Widgets/Messenger/wait.gif"
        }
    }
}
