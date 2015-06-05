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

import "../../../../../Core/Styles.js" as Styles
import "../../../../../Core/App.js" as App
import "../../../../../Core/EmojiOne.js" as EmojiOne
import "../../../../../Core/StringHelper.js" as StringHelper

Item {
    id: root

    property alias nickname: nicknameText.text
    property alias date: dateText.text
    property string body
    property alias avatar: avatarImage.source

    property bool isStatusMessage: false
    property bool isSelfMessage: false
    property bool firstMessageInGroup: false

    signal linkActivated(string link);
    signal userClicked();

    width: parent.width
    height: messageRow.height + messageRow.y

    Row {
        id: messageRow

        width: parent.width
        height: childrenRect.height

        y: root.firstMessageInGroup ? 10 : 2

        //Avatar
        Item {
            width: 110
            height: 32

            Item {
                property bool needDraw: !root.isSelfMessage && root.firstMessageInGroup

                width: 32
                height: 32

                anchors {
                    right: parent.right
                    top: parent.top
                    rightMargin: 12
                }

                Image {
                    id: avatarImage

                    width: 32
                    height: 32
                    visible: parent.needDraw
                }

                CursorMouseArea {
                    anchors.fill: parent
                    onClicked: root.userClicked();
                }
            }
        }

        //Message body
        Item {
            width: messageRow.width - 220
            height: messageContainer.height

            Item {
                id: messageContainer

                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                    leftMargin: root.isSelfMessage ? 30 : 0
                }

                height: messageColumn.height + 20

                Rectangle { // background
                    id: itemBackground

                    anchors.fill: parent

                    color: root.isSelfMessage ?
                               Styles.style.light :
                               Styles.style.contentBackgroundLight

                    opacity: root.isSelfMessage ? 0.15 : 0.08

                    //Left-right arrow
                    // INFO из-за прозрачности приходиться отдельно вырезать треугольник.
                    Item {
                        anchors {
                            left: root.isSelfMessage ? parent.right : parent.left
                            top: parent.top
                            leftMargin: root.isSelfMessage ? 0 : -7
                            topMargin: 15
                        }

                        width: 7
                        height: 7
                        clip: true

                        Rectangle {
                            color: itemBackground.color

                            x: root.isSelfMessage ? -4 : 4
                            width: 7
                            height: 7
                            rotation: 45
                            visible: root.firstMessageInGroup
                        }
                    }
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

                        color: Styles.style.menuText

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
                                                           hyperLinkStyle: Styles.style.linkText,
                                                           smileResolver: EmojiOne.ns.toImage,
                                                           serviceResolver: App.serviceItemByServiceId
                                                       })

                        color: root.isSelfMessage ? Styles.style.chatButtonText : Styles.style.textBase
                        font {
                            family: "Arial"
                            pixelSize: 12
                            italic: root.isStatusMessage
                        }

                        onLinkActivated: root.linkActivated(link);
                    }
                }
            }
        }

        //Date
        Item {
            width: 110
            height: 30

            Text {
                id: dateText

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    leftMargin: 12
                }

                color: Styles.style.textTime

                font {
                    family: "Arial"
                    pixelSize: 12
                }

                visible: !root.isStatusMessage
            }
        }
    }
}
