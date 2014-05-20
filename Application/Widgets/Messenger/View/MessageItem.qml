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

Item {
    id: root

    property alias nickname: nicknameText.text
    property alias date: dateText.text
    property alias body: messageBody.text

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
            // HACK
            source: "http://images.gamenet.ru/pics/user/avatar/small/empty2.jpg"
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

                color: "#243148"
            }

            Text {
                id: dateText

                visible: !root.isStatusMessage
                color: "#A4B0BA"
                anchors.right: parent.right
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

                selectByMouse: false
                readOnly: true
                wrapMode: TextEdit.Wrap
                width: parent.width
                textFormat: TextEdit.PlainText

                color: root.isStatusMessage ? "#A4B0BA" : "#5B6F81"
                font.italic: root.isStatusMessage
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
        color: "#E1E5E8"
    }
}
