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

import "../../../../../Core/Styles.js" as Styles
import "../../../../../Core/App.js" as App
import "../../../../../Core/EmojiOne.js" as EmojiOne
import "../../../../../../GameNet/Core/Strings.js" as Strings

import "../../../Models/StringHelper.js" as StringHelper

Item {
    id: root

    property alias nickname: nicknameText.text
    property alias date: dateText.text
    property string body
    property alias avatar: avatarImage.source

    property bool isStatusMessage: false
    property bool isSelfMessage: false
    property bool firstMessageInGroup: false

    width: parent.width
    height: messageRow.height + messageRow.y

    Row {
        id: messageRow

        width: parent.width
        height: childrenRect.height

        y: root.firstMessageInGroup ? 10 : 2

        //Avatar
        Item {
            property bool needDraw: !root.isSelfMessage && root.firstMessageInGroup

            width: 52
            height: 32

            Image {
                id: avatarImage

                anchors {
                    left: parent.left
                    top: parent.top

                    leftMargin: 10
                    rightMargin: 10
                }

                visible: parent.needDraw
            }
        }

        //Message body
        Item {
            width: 485
            height: messageContainer.height

            Rectangle {
                id: messageContainer

                color: root.isSelfMessage ?
                           Styles.style.messengerChatDialogMessageSelfText :
                           Styles.style.messengerChatDialogMessageCompanionText

                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                    leftMargin: root.isSelfMessage ? 20 : 0
                    rightMargin: 10
                }

                height: messageColumn.height + 20

                //Left-right arrow
                Rectangle {

                    color: parent.color

                    anchors {
                        left: root.isSelfMessage ? parent.right : parent.left
                        top: parent.top
                        leftMargin: root.isSelfMessage ? -3 : -4
                        topMargin: 15
                    }

                    width: 7
                    height: 7

                    rotation: 45

                    visible: root.firstMessageInGroup
                }

                Column {
                    id: messageColumn

                    spacing: 10

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right

                        leftMargin: 10
                        rightMargin: 10
                        topMargin: 10
                    }

                    //Header
                    Text {
                        id: nicknameText

                        color: Styles.style.messengerChatDialogMessageNicknameText

                        font {
                            family: "Arial"
                            pixelSize: 14
                        }

                        visible: !root.isSelfMessage && root.firstMessageInGroup
                    }

                    TextEdit {
                        id: messageBody

                        anchors {
                            left: parent.left
                            right: parent.right
                        }

                        wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                        readOnly: true
                        selectByMouse: true
                        textFormat: TextEdit.RichText
                        text: StringHelper.prepareText(root.body, {
                                                           hyperLinkStyle: Styles.style.messengerChatDialogHyperlinkColor,
                                                           smileResolver: EmojiOne.ns.toImage,
                                                           serviceResolver: App.serviceItemByServiceId
                                                       })

                        color: root.isStatusMessage
                               ? Styles.style.messengerChatDialogMessageStatusText
                               : Styles.style.messengerChatDialogMessageText

                        font {
                            family: "Arial"
                            pixelSize: 12
                            italic: root.isStatusMessage
                        }

                        onLinkActivated: {
                            var serviceId
                            , gameNetPattern = "https://gamenet.ru"
                            , startServicePattern = "gamenet://startservice/";

                            if (link.indexOf(gameNetPattern) === 0) {
                                App.openExternalUrlWithAuth(link);
                                return;
                            }

                            if (link.indexOf(startServicePattern) === 0) {
                                serviceId = link.substring(startServicePattern.length);

                                if (App.serviceExists(serviceId)) {
                                    App.selectService(serviceId);
                                    App.downloadButtonStart(serviceId);
                                }
                                return;
                            }

                            App.openExternalUrl(link);
                        }
                    }
                }
            }
        }
        //Date
        Item {
            width: 52
            height: 30

            Text {
                id: dateText

                anchors {
                    top: parent.top
                    topMargin: 10
                }

                color: Styles.style.messengerChatDialogMessageDateText

                font {
                    family: "Arial"
                    pixelSize: 12
                }

                visible: !root.isStatusMessage
            }
        }
    }
}
