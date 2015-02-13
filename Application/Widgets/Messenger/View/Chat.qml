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
import "./Blocks/ChatDialog/Smile" as SmilesBlock

import "../Models/Messenger.js" as MessengerJs
import "../../../Core/App.js" as App

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
            top: parent.top
            topMargin: header.height
            left: parent.left
            right: parent.right
        }

        height: MessengerJs.isSelectedGamenet()
                    ? root.height - header.height
                    : separator.y - header.height

    }

    ChatDialog.MessageInput {
        id: messageInput

        visible: !MessengerJs.isSelectedGamenet()
        width: parent.width

        anchors {
            bottom: parent.bottom
            top: body.bottom
        }

        onCloseDialogPressed: {
            MessengerJs.closeChat();
            MessengerJs.setSmilePanelVisible(false);
        }
        sendAction: model.settings.sendAction

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

    SmilesBlock.SmileButton {
        id: smileButton

        anchors {
            right: parent.right
            top: messageInput.top
            rightMargin: 118 + 5
            topMargin: 6 + 6
        }
        onClicked: MessengerJs.setSmilePanelVisible(true);
    }

    SmilesBlock.SmilePanel {
        id: smilePanel

        anchors {
            bottom: smileButton.top
            bottomMargin: 18
            horizontalCenter: smileButton.horizontalCenter
            horizontalCenterOffset: -10
        }
        visible: MessengerJs.smilePanelVisible()
        onInsertSmile: {
            MessengerJs.setSmilePanelVisible(false);
            messageInput.insertText(tag);
            messageInput.forceActiveFocus();
        }
        onCloseRequest: MessengerJs.setSmilePanelVisible(false);

        Connections {
            target: App.signalBus()
            onLeftMousePress: {
                var posInItem = smilePanel.mapFromItem(rootItem, x, y);
                var contains = posInItem.x >= 0 && posInItem.y >=0
                        && posInItem.x <= smilePanel.width && posInItem.y <= smilePanel.height;
                if (!contains) {
                    MessengerJs.setSmilePanelVisible(false);
                }
            }
        }
    }
}
