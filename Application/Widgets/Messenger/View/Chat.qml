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

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

import "./Blocks/ChatDialog" as ChatDialog
import "../Models/Messenger.js" as MessengerJs

WidgetView {
    id: root

    implicitWidth: parent.width
    implicitHeight: parent.height

    visible: MessengerJs.userSelected()

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    ChatDialog.Header {
    }

    ChatDialog.Body {
       anchors {
           fill: parent
           topMargin: 52
           bottomMargin: MessengerJs.isSelectedGamenet() ? 0 : 78
       }
    }

    ChatDialog.MessageInput {
        visible: !MessengerJs.isSelectedGamenet()
        width: parent.width
        height: 78
        anchors.bottom: parent.bottom
    }
}
