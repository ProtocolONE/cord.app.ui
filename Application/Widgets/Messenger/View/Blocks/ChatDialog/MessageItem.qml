/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0

import "../" as Blocks

Item {
    id: root

    property alias nickname: nicknameText.text
    property alias date: dateText.text
    property string fulldate
    property string body
    property alias avatar: avatarImage.source

    property bool isStatusMessage: false
    property bool isSelfMessage: false
    property bool firstMessageInGroup: false
    property bool isReplacedMessage: false

    property alias isGameNetMember: shieldItem.visible

    signal linkActivated(string link);
    signal userClicked();

    width: parent.width
    height: messageRow.height + messageRow.y

    function getSelectedText() {
        var text = '';
        if (messageBody.selectedText.length > 0) {
            var ftext = messageBody.getFormattedText(messageBody.selectionStart, messageBody.selectionEnd);
            text = TextDocumentHelper.stripHtml(EmojiOne.ns.htmlToShortname(ftext));
        }
        return text;
    }


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
                id: avatarImageItem

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

                Image {

                    width: 32
                    height: 32

                    anchors {
                        right: parent.right
                        top: parent.top
                        rightMargin: 12
                    }

                    visible: avatarImageItem.needDraw && root.isReplacedMessage
                    source: installPath + "Assets/Images/Application/Widgets/Messenger/edit_icon.png"
                }

                CursorMouseArea {
                    visible: parent.needDraw
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
                               Styles.light :
                               Styles.contentBackgroundLight

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
                    Item  {
                        width: parent.width
                        height: nicknameText.height
                        visible: !root.isSelfMessage && root.firstMessageInGroup

                        Text {
                            id: nicknameText

                            color: Styles.menuText

                            width: parent.width -
                                   (shieldItem.visible ? (shieldItem.width + 5) : 0)

                            elide: Text.ElideRight

                            font {
                                family: "Arial"
                                pixelSize: 14
                            }
                        }

                        Blocks.GameNetShield {
                            id: shieldItem

                            anchors {
                                left: parent.left
                                leftMargin: nicknameText.paintedWidth + 5
                            }
                        }
                    }

                    Item {
                        id: bodyWrapper

                        width: parent.width
                        height: messageBody.height

                        TextEdit {
                            id: messageBody

                            anchors {
                                left: parent.left
                                right: parent.right
                                rightMargin: 22
                            }

                            wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                            readOnly: true
                            selectByMouse: true
                            textFormat: TextEdit.RichText
                            text: AppStringHelper.prepareText(root.body, {
                                                               hyperLinkStyle: Styles.linkText,
                                                               smileResolver: EmojiOne.ns.toImage,
                                                               serviceResolver: App.serviceItemByServiceId,
                                                               quoteAuthorColor: Styles.messengerQuoteAuthorColor
                                                           })

                            color: root.isSelfMessage ? Styles.chatButtonText : Styles.textBase
                            font {
                                family: "Arial"
                                pixelSize: 12
                                italic: root.isStatusMessage
                            }

                            onLinkActivated: root.linkActivated(link);

                            Keys.onPressed: {
                                if ((event.key === Qt.Key_Insert) && (event.modifiers === Qt.ControlModifier) ||
                                    (event.key === Qt.key_c) && (event.modifiers === Qt.ControlModifier)) {
                                    var text = root.getSelectedText();
                                    if (text.length > 0) {
                                        ClipboardAdapter.setQuote(text, root.nickname, root.fulldate);
                                    }
                                    event.accepted = true;
                                }
                            }

                            MouseArea {
                                  anchors.fill: parent
                                  cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                                  acceptedButtons: Qt.NoButton
                              }
                        }

                        Image {
                            id: idEditIcon

                            width: 16
                            height: 16

                            anchors {
                                left: parent.right
                                top: parent.top
                                leftMargin: -15
                            }

                            visible: root.isReplacedMessage
                            source: installPath + "Assets/Images/Application/Widgets/Messenger/edit_icon.png"
                        }
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

                color: Styles.textTime

                font {
                    family: "Arial"
                    pixelSize: 12
                }

                visible: !root.isStatusMessage
            }
        }
    }
}
