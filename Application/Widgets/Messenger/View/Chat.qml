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
        id: header
    }

    ChatDialog.Body {
        id: body

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            topMargin: header.height
        }
        height: separator.y - header.height

    }

    ChatDialog.MessageInput {
        id: messageInput

        visible: !MessengerJs.isSelectedGamenet()
        width: parent.width

        anchors {
            bottom: parent.bottom
            top: body.bottom
        }

        Connections {
            target: MessengerJs.instance()
            onSelectedUserChanged: {
                if (messageInput.visible) {
                    messageInput.forceActiveFocus();
                }
            }
        }
    }

    CursorMouseArea {
        id: separator

        anchors { left: parent.left; right: parent.right }
        height: 8

        acceptedButtons: Qt.LeftButton
        cursor: CursorArea.SizeVerCursor
        visible: messageInput.visible
        drag {
            target: separator
            axis: Drag.YAxis
            minimumY: parent.height - 250
            maximumY: parent.height - 78
        }

        onReleased: model.settings.chatBodyHeight = separator.y;
        Component.onCompleted: separator.y = model.settings.chatBodyHeight;
    }
}
