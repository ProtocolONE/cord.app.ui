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

import Gamenet.Controls 1.0
import GameNet.Components.Widgets 1.0
import Application.Controls 1.0

import "../Models/Messenger.js" as MessengerJs

WidgetView {
    id: root

    implicitWidth: 590
    implicitHeight: 600
    visible: MessengerJs.userSelected()

    Rectangle {
        width: parent.width
        height: 52
        color: "#253149"

        Row {
            anchors.fill: parent

            Item {
                width: parent.height
                height: parent.height

                Image {
                    // HACK
                    source: "http://images.gamenet.ru/pics/user/avatar/small/empty2.jpg"
                    anchors.centerIn: parent
                }
            }

            Item {
                width: parent.width - parent.height
                height: parent.height

                Text {
                    color: "#FFFFFF"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                    text: MessengerJs.selectedUserNickname();
                }
            }
        }

        ImageButton {
            anchors {
                top: parent.top
                right: parent.right
            }

            width: 32
            height: 32
            styleImages: ButtonStyleImages {
                normal: installPath + "/images/close.png"
                hover: installPath + "/images/close.png"
                disabled: installPath + "/images/close.png"
            }

            style: ButtonStyleColors {
                normal: "#00000000"
                hover: "#00000000"
                disabled: "#00000000"
            }

            onClicked: MessengerJs.closeChat();
        }
    }

    Rectangle {
        color: "#F0F5F8"
        anchors {
            fill: parent
            topMargin: 52
            bottomMargin: 78
        }
        clip: true

        ListView {
            id: messageList

            cacheBuffer: 100
            boundsBehavior: Flickable.StopAtBounds
            interactive: true

            anchors.fill: parent

            model: MessengerJs.selectedUserMessages()
            spacing: 5
            onCountChanged: messageList.positionViewAtEnd();

            delegate: MessageItem {
                width: root.width
                nickname: MessengerJs.getNickname(model)
                date: Qt.formatDateTime(new Date(model.date), "hh:mm")
                body: model.text
                isStatusMessage: model.isStatusMessage
            }
        }

        ScrollBar {
            flickable: messageList
            anchors.right: parent.right
            height: parent.height
        }
    }

    MessageInput {
        width: parent.width
        height: 78
        anchors.bottom: parent.bottom
    }
}
