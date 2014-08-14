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
import "../../../../../../GameNet/Core/Strings.js" as Strings

Item {
    id: root

    property alias nickname: nicknameText.text
    property alias date: dateText.text
    property string body
    property alias avatar: avatarImage.source

    property bool isStatusMessage: false

    implicitHeight: messageHeader.height + messageBody.height + 31

    Item {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 10
            bottomMargin: 11
            leftMargin: 20
            rightMargin: 20
        }

        Image {
            id: avatarImage

            width: 32
            height: 32
        }

        Item { // message header
            id: messageHeader

            height: 13
            anchors {
                left: parent.left
                leftMargin: 42
                right: parent.right
            }

            Text {
                id: nicknameText

                color: Styles.style.messengerChatDialogMessageNicknameText
                font {
                    family: "Arial"
                    pixelSize: 14
                }
            }

            Text {
                id: dateText

                visible: !root.isStatusMessage
                color: Styles.style.messengerChatDialogMessageDateText
                anchors.right: parent.right
                font {
                    family: "Arial"
                    pixelSize: 12
                }
            }
        }

        Item {
            height: messageBody.height
            anchors {
                left: parent.left
                leftMargin: 42
                right: parent.right
                top: parent.top
                topMargin: 23
            }

            TextEdit {
                id: messageBody

                function replaceHyperlinks(message) {
                    return message.replace(/(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\x{00a1}\-\x{ffff}0-9]+-?)*[a-z\x{00a1}\-\x{ffff}0-9]+)(?:\.(?:[a-z\x{00a1}\-\x{ffff}0-9]+-?)*[a-z\x{00a1}\-\x{ffff}0-9]+)*(?:\.(?:[a-z\x{00a1}\-\x{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?/ig, function(e) {
                        return "<a style='color:" +
                                Styles.style.messengerChatDialogHyperlinkColor +
                                "' href='" + e + "'>" + e + "</a>";
                    });
                }

                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                width: parent.width
                readOnly: true
                selectByMouse: true
                textFormat: TextEdit.RichText
                text: replaceHyperlinks(Strings.stripTags(root.body))
                color: root.isStatusMessage
                       ? Styles.style.messengerChatDialogMessageStatusText
                       : Styles.style.messengerChatDialogMessageText

                font {
                    family: "Arial"
                    pixelSize: 12
                    italic: root.isStatusMessage
                }

                onLinkActivated: {
                    if (link.indexOf("http://gamenet.ru") === 0) {
                        App.openExternalUrlWithAuth(link);
                    } else {
                        App.openExternalUrl(link);
                    }
                }
            }
        }
    }

    Rectangle {
        height: 1
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 20
            rightMargin: 20
        }
        color: Qt.darker(Styles.style.messengerChatDialogBodyBackground, Styles.style.darkerFactor)
    }
}
