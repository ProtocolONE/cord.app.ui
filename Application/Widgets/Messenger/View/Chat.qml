import QtQuick 2.4
import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Controls 1.0
import Application.Core 1.0
import Application.Core.Styles 1.0

import "./Blocks/ChatDialog" as ChatDialog
import "./Blocks/ChatDialog/Smile" as SmilesBlock

import "../Models/Messenger.js" as MessengerJs

import "./Blocks/Group" as GroupBlock

WidgetView {
    id: root

    function recheckInputSize() {
        if (!root.model) {
            return;
        }

        // INFO Небольшой хак из-за старнной инициализации
        // высоты при старте приложения
        if (root.height <= 0) {
            return;
        }

        var minimumY = root.height - 250,
            maximumY = root.height - 78;

        // INFO в оверлее этот код выполняется раньше, чем загрузка настройки
        if (separator.y == 0) {
            separator.y = root.model.settings.chatBodyHeight;
        }

        if (separator.y < minimumY) {
            separator.y = minimumY;
            root.model.settings.chatBodyHeight = separator.y;
        } else if (separator.y > maximumY) {
            separator.y = maximumY;
            root.model.settings.chatBodyHeight = separator.y;
        }
    }

    implicitWidth: parent ? parent.width : 0
    implicitHeight: parent ? parent.height : 0

    visible: MessengerJs.userSelected()

    onVisibleChanged: root.recheckInputSize();
    onModelChanged: root.recheckInputSize();
    onHeightChanged: root.recheckInputSize();

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
    }

    ContentBackground {
        anchors.fill: parent
        opacity: 1
    }

    Rectangle {
        x: -1
        height: parent.height
        width: 1
        color: Styles.contentBackgroundDark
        opacity: Styles.baseBackgroundOpacity
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
                    ? (root.height - header.height - 2)
                    : (separator.y - header.height)

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
        sendAction: !!model ? model.settings.sendAction : ""

        Connections {
            target: MessengerJs.instance()
            onSelectedUserChanged: {
                if (messageInput.visible) {
                    messageInput.forceActiveFocus();
                }
            }
        }

        Connections {
            target: body
            onEditMessage : {
                messageInput.setMessage(message);
                Ga.trackEvent('ContextMenu', 'editMessage', 'edit');
            }
            onMessageQuote : {
                messageInput.setQuote(messageItem, message);
                messageInput.forceActiveFocus();
                Ga.trackEvent('ContextMenu', 'quote', 'insert');
            }
        }
    }

    CursorMouseArea {
        id: separator

        anchors { left: parent.left; right: parent.right }
        height: 8

        acceptedButtons: Qt.LeftButton
        cursor: Qt.SizeVerCursor
        visible: messageInput.visible
        drag {
            target: separator
            axis: Drag.YAxis
            minimumY: parent.height - 250
            maximumY: parent.height - 78
        }

        onReleased: model.settings.chatBodyHeight = separator.y;
        Component.onCompleted: separator.y = root.model.settings.chatBodyHeight;
    }

    SmilesBlock.SmileButton {
        id: smileButton

        anchors {
            right: parent.right
            top: messageInput.top
            rightMargin: 118
            topMargin: 6 + 10
        }
        onClicked: MessengerJs.setSmilePanelVisible(true);
    }

    Component {
        id: smilePanelComponent

        SmilesBlock.SmilePanel {
            id: smilePanel

            onInsertSmile: {
                messageInput.insertText(tag);
                messageInput.forceActiveFocus();
                MessengerJs.setSmilePanelVisible(false);
            }
            onCloseRequest: MessengerJs.setSmilePanelVisible(false);

            Connections {
                target: SignalBus
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

    Loader {
        anchors {
            bottom: smileButton.top
            bottomMargin: 18
            horizontalCenter: smileButton.horizontalCenter
            horizontalCenterOffset: -10
        }

        sourceComponent: MessengerJs.smilePanelVisible() ? smilePanelComponent : null
    }

    GroupBlock.EditView {
        visible: MessengerJs.editGroupModel().isActive()
        anchors {
            right: parent.right
            rightMargin: 24
            top: parent.top
            topMargin: 60+6
        }
    }

    ContentThinBorder {}
}
