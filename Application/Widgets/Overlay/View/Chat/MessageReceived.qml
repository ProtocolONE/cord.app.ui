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

import GameNet.Controls 1.0
import Application.Controls 1.0
import Application.Controls.MessagePopup 1.0

import "../../Core" as OverlayCore

import "../../../../Core/App.js" as App
import "../../../../Core/Styles.js" as Styles
import "../../../../Core/moment.js" as Moment
import "../../../../Core/EmojiOne.js" as EmojiOne
import "../../../../Core/StringHelper.js" as StringHelper

OverlayCore.PopupBase {
    id: root

    signal closeButtonClicked()

    property variant messenger

    property string jid
    property string messageText
    property string avatar: messenger.userAvatar(root)
    property string nickname: messenger.getNickname(root)
    property string playingGameServiceId: messenger.userPlayingGame(root)
    property int newHeight: bodyItem.height + 60 + (playingRow.visible ? playingRow.height : 0)
    property variant message
    property bool isCropped: false

    onMessageChanged: {
        var messageDate = Date.now(),
            lastDelegateHeight,
            maximumHeight,
            maximumListViewHeight = 200 - (playingRow.visible ? playingRow.height + 12 : 0);

        root.restartDestroyTimer();

        if (root.isCropped) {
            return;
        }

        if (root.message.stamp != "Invalid Date") {
            messageDate = +(Moment.moment(root.message.stamp));
        }

        listModel.append({body: root.message.body, messageDate: messageDate, maximumHeight: -1});

        if (listViewMessage.calcHeight() > maximumListViewHeight) {
            lastDelegateHeight = listViewMessage.delegateHeights[listViewMessage.count - 1];
            maximumHeight = maximumListViewHeight - (listViewMessage.calcHeight() - lastDelegateHeight);

            listModel.setProperty(listViewMessage.count - 1, 'maximumHeight', maximumHeight);
            root.isCropped = true;
        }
    }

    width: 250
    height: Math.max(newHeight, 110)

    Rectangle {
        anchors {
            fill: parent
            rightMargin: 1
            bottomMargin: 1
        }
        color: Styles.style.trayPopupBackground
        border.color: Styles.style.trayPopupBackgroundBorder
    }

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: 50

            Row {
                anchors { fill: parent; margins: 10 }
                spacing: 8

                Image {
                    source: avatar
                    width: 32
                    height: 32
                    cache: true
                    asynchronous: true
                }

                Text {
                    text: nickname
                    color: Styles.style.trayPopupTextHeader
                    width: 160
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                    font { pixelSize: 18; family: "Arial"}
                }
            }
        }

        Item {
            id: bodyItem

            width: parent.width
            height: listViewMessage.height

            ListView {
                id: listViewMessage

                property variant delegateHeights: {}

                function refreshHeight() {
                    listViewMessage.height = calcHeight() + 1;
                }

                onDelegateHeightsChanged: refreshHeight();

                function calcHeight() {
                    var result = 0
                        , i;

                    for (i in listViewMessage.delegateHeights) {
                        result += listViewMessage.delegateHeights[i];
                    }

                    return Math.max(40, result);
                }

                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                    leftMargin: 10
                    rightMargin: 10
                }

                interactive: false

                model: ListModel {
                    id: listModel
                }

                delegate: MessageReceivedDelegate {
                    externalMaximumHeight: model.maximumHeight || -1
                    date: model.messageDate
                    body: StringHelper.prepareText(model.body, {
                                                                 hyperLinkStyle: Styles.style.messengerChatDialogHyperlinkColor,
                                                                 smileResolver: EmojiOne.ns.toImage,
                                                                 serviceResolver: App.serviceItemByServiceId
                                                               })
                    maximumHeight: model.maximumHeight

                    width: listViewMessage.width

                    onHeightChanged: {
                        var tmp = listViewMessage.delegateHeights;
                        tmp[index] = height;
                        listViewMessage.delegateHeights = tmp;
                    }
                }
            }

            MessageCropElement {
                anchors {
                    left: parent.left
                    top: parent.bottom
                    right: parent.right
                    topMargin: -4
                }

                visible: root.isCropped
            }
        }
    }

    MessagePlayingRow {
        id: playingRow

        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: 10
            bottomMargin: 6
        }

        playingGameServiceId: root.playingGameServiceId
    }

    Image {
        id: closeButtonImage

        anchors { right: parent.right; top: parent.top; rightMargin: 9; topMargin: 9 }
        source: installPath + "/Assets/Images/Application/Core/TrayPopup/popupClose.png"
        opacity: closeButtonImageMouser.containsMouse ? 1 : 0.75

        Behavior on opacity {
            PropertyAnimation {
                duration: 225
            }
        }

        CursorMouseArea {
            id: closeButtonImageMouser

            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.closeButtonClicked();
                root.shadowDestroy();
            }
        }
    }
}
