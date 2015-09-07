/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4

import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import Application.Core 1.0

import "../../Core/Popup.js" as Popup

Item {
    id: root

    property bool isShown: chat.visible

    property variant messenger
    property variant settings

    property variant hotkey: JSON.parse(settings.messengerOpenChatHotkey)
    property bool showNotify: settings.messengerShowChatOverlayNotify

    signal blockMouse();
    signal blockNone();

    function resetCoord() {
        if (chat.x > 0 && root.width > 0 && chat.x > root.width - mouseArea.drag.minimumX - chat.width) {
            chat.x = root.width - mouseArea.drag.minimumX - chat.width;
        }

        if (chat.y > 0 && root.height > 0 && chat.y > root.height - mouseArea.drag.minimumY - chat.height) {
            chat.y = root.height - mouseArea.drag.minimumY - chat.height;
        }
    }

    onHeightChanged: root.resetCoord();
    onWidthChanged: root.resetCoord();


    function keyDown(key, modifiers, text) {
        if (key !== root.hotkey.key) {
            return;
        }

        if (hotkey.modifiers && !(modifiers & root.hotkey.modifiers)) {
            return;
        }

        chat.visible = !chat.visible;
    }

    function init() {
        Popup.init(root);
        notifyTimer.start();
    }

    PopupHelper {
        enabled: root.showNotify
        onOpenChat: chat.visible = true;
        messenger: root.messenger
        chatVisible: chat.visible
    }

    Rectangle {
        id: substrate

        anchors.fill: parent
        color: '#000000'
        opacity: 0.7
        visible: chat.visible
    }

    Item {
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: chat.visible = false;
            visible: chat.visible
        }

        Item {
            id: chat

            x: 25
            y: 25

            width: row.width
            height: 558
            visible: false
            clip: true

            onWidthChanged: root.resetCoord();

            MouseArea {
                id: mouseArea

                height: parent.height
                width: row.childrenRect.width

                drag {
                    target: parent
                    axis: Drag.XandYAxis
                    minimumY: 25
                    maximumY: root.height - parent.height - drag.minimumY
                    minimumX: 25
                    maximumX: root.width - parent.width - drag.minimumX
                    filterChildren: true
                }
            }

            Row {
                id: row

                height: parent.height

                WidgetContainer {
                    height: parent.height
                    width: 230
                    widget: 'Messenger'
                    view: 'Contacts'
                }

                Row {
                    height: parent.height

                    WidgetContainer {
                        height: parent.height
                        width: 590
                        widget: 'Messenger'
                        view: 'Chat'
                        visible: messenger ? messenger.userSelected() : false
                    }

                    WidgetContainer {
                        widget: 'DetailedUserInfo'
                        view: 'DetailedUserInfoView'
                    }
                }
            }
        }
    }

    Timer {
        id: notifyTimer

        interval: 4000
        onTriggered: {
            chatNotify.opacity = 1;
            notifyTimerClose.start();
        }
    }

    Timer {
        id: notifyTimerClose

        interval: 5000
        onTriggered: chatNotify.opacity = 0;
    }

    ChatNotify {
        id: chatNotify

        width: 240
        height: 92

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }

        opacity: 0
        text: qsTr("MESSENGER_OVERLAY_POPUP_HELPER_TEXT").arg(root.hotkey.name)

        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: chatNotify.opacity = 0;
            onEntered: root.blockMouse();
            onExited: root.blockNone();
        }
    }
}



