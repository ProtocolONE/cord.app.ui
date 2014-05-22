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
import Application.Controls 1.0

import "../Models/Messenger.js" as MessengerJs

Rectangle {
    id: root

    color: "#FFFFFF"

    property int pauseTimeout: 3
    property int inactiveTimeout: 12

    signal inputStatusChanged(string value);

    QtObject {
        id: d

        property string activeStatus: ""

        function sendMessage() {
            if (messengerInput.text.length > 0) {
                MessengerJs.sendMessage(MessengerJs.selectedUser(), messengerInput.text);
                messengerInput.text = "";
                d.activeStatus = "Active";
            }
        }

        onActiveStatusChanged: MessengerJs.sendInputStatus(MessengerJs.selectedUser(), d.activeStatus);
    }

    Connections {
        target: MessengerJs.instance()
        onSelectedUserChanged: {
            var user;
            if (messengerInput.text.length > 0) {
                user = MessengerJs.previousUser();
                if (user.isValid()) {
                    user.inputMessage = messengerInput.text;
                }
            }

            user = MessengerJs.selectedUser();
            if (user.isValid()) {
                messengerInput.text = user.inputMessage;
                user.inputMessage = "";
                messengerInput.cursorPosition = messengerInput.text.length;
            }
        }
    }

    Row {
        anchors {
            fill: parent
            margins: 10
        }

        spacing: 10

        Rectangle {
            height: parent.height
            width: parent.width - 110
            color: "#E6E6E6"

            Rectangle {
                color: "#FFFFFF"
                anchors {
                    fill: parent
                    margins: 2
                }

                Item {
                    id: inputContainer

                    anchors {
                        fill: parent
                        margins: 8
                    }

                    Flickable {
                        id: inputFlick

                        width: parent.width
                        height: parent.height

                        contentWidth: messengerInput.paintedWidth
                        contentHeight: messengerInput.paintedHeight
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true

                        function ensureVisible(r) {
                            if (contentX >= r.x)
                                contentX = r.x;
                            else if (contentX+width <= r.x+r.width)
                                contentX = r.x+r.width-width;
                            if (contentY >= r.y)
                                contentY = r.y;
                            else if (contentY+height <= r.y+r.height)
                                contentY = r.y+r.height-height;
                        }

                        TextEdit {
                            id: messengerInput

                            width: inputFlick.width
                            height: inputFlick.height

                            selectByMouse: true
                            wrapMode: TextEdit.Wrap

                            font {
                                pixelSize: 12
                                family: "Arial"
                            }

                            color: "#a4b0ba"

                            onCursorRectangleChanged: inputFlick.ensureVisible(cursorRectangle);

                            Keys.onReturnPressed: {
                                if (event.modifiers !== Qt.NoModifier)  {
                                    event.accepted = false;
                                    return;
                                }

                                d.sendMessage();
                            }

                            onTextChanged: {
                                if (text.length <= 0) {
                                    d.activeStatus = "Active";
                                    composingTimer.stop();
                                    composingTimer.count = 0;
                                } else {
                                    d.activeStatus = "Composing"
                                    composingTimer.count = 0;
                                    composingTimer.start();
                                }

                            }
                        }

                        Timer {
                            id: composingTimer

                            property int count: 0

                            running: false
                            repeat: true
                            interval: 1000
                            onTriggered: {
                                count++;

                                if (composingTimer.count >= root.inactiveTimeout) {
                                    d.activeStatus = "Inactive"
                                    return;
                                }

                                if (composingTimer.count >= root.pauseTimeout) {
                                    d.activeStatus = "Paused"
                                    return;
                                }
                            }
                        }
                    }
                }

                ScrollBar {
                    flickable: inputFlick
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }

                    scrollbarWidth: 5
                }
            }
        }

        Item {
            width: 100
            height: parent.height

            Column {
                anchors.fill: parent
                spacing: 10

                Button {
                    width: 91
                    height: 24
                    style: ButtonStyleColors {
                        normal: "#1ABC9C"
                        hover: "#019074"
                    }

                    onClicked: d.sendMessage()

                    Text {
                        anchors.centerIn: parent
                        font {
                            pixelSize: 16
                            family: "Arial"
                        }

                        color: "#FAFAFA"
                        text: qsTr("MESSENGER_SEND_BUTTON")
                    }

                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "#8596A6"
                    text: qsTr("MESSENGER_SEND_BUTTON_MESSAGE")
                }
            }
        }
    }
}
