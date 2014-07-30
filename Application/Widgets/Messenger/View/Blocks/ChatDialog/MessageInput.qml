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
import Application.Controls 1.0

import "../../../../../Core/App.js" as App
import "../../../../../Core/Styles.js" as Styles
import "../../../Models/Messenger.js" as MessengerJs
import "../../../Models/Settings.js" as Settings

FocusScope {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Styles.style.messengerMessageInputBackground
    }

    property int sendAction
    property int pauseTimeout: 3
    property int inactiveTimeout: 12

    signal inputStatusChanged(string value);
    signal closeDialogPressed();

    QtObject {
        id: d

        property string activeStatus: "Active"


        function sendMessage() {
            if (messengerInput.text.length > 0) {
                MessengerJs.sendMessage(MessengerJs.selectedUser(), messengerInput.text);
                messengerInput.text = "";
                d.setActiveStatus(MessengerJs.selectedUser(), "Active");
            }
        }

        function setActiveStatus(user, status) {
            if (d.activeStatus === status) {
                return;
            }

            d.activeStatus = status;
            MessengerJs.sendInputStatus(user, status);
        }

        function updateUserSelectedText() {
            var user = MessengerJs.previousUser();

            if (user.isValid()) {
                d.setActiveStatus(user, "Active");

                if (messengerInput.text.length > 0) {
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

    Connections {
        target: MessengerJs.instance()
        onSelectedUserChanged: d.updateUserSelectedText()
    }

    Rectangle {
        width: 4
        height: 4
        border { color: Styles.style.messengerMessageInputPin }
        color: '#00000000'
        radius: 2
        anchors { top: parent.top; topMargin: 2; left: parent.left; leftMargin: 10 + (parent.width - 110) / 2 }
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
            color: Styles.style.messengerMessageInputBorder

            Rectangle {
                color: Styles.style.messengerMessageInputTextBackground
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

                            function appendNewLine() {
                                messengerInput.text = messengerInput.text + "\n";
                                messengerInput.cursorPosition = messengerInput.text.length;
                            }

                            width: inputFlick.width
                            height: inputFlick.height
                            focus: true

                            selectByMouse: true
                            wrapMode: TextEdit.Wrap

                            font {
                                pixelSize: 12
                                family: "Arial"
                            }


                            color: Styles.style.messengerMessageInputText

                            onCursorRectangleChanged: inputFlick.ensureVisible(cursorRectangle);

                            Keys.onEnterPressed: {
                                switch (root.sendAction) {
                                case Settings.SendShortCut.CtrlEnter:
                                    {
                                        if (event.modifiers & Qt.ControlModifier) {
                                            d.sendMessage();
                                        } else {
                                            messengerInput.appendNewLine();
                                        }
                                        event.accepted = true;
                                        return;
                                    }
                                case Settings.SendShortCut.Enter:
                                    {
                                        if (event.modifiers === Qt.KeypadModifier) {
                                            d.sendMessage();
                                        } else {
                                            messengerInput.appendNewLine();
                                        }
                                        event.accepted = true;
                                        return;
                                    }
                                case Settings.SendShortCut.ButtonOnly:
                                    {
                                        messengerInput.appendNewLine();
                                        event.accepted = true;
                                        return;
                                    }
                                }
                                event.accepted = false;
                            }

                            Keys.onReturnPressed: {
                                switch (root.sendAction) {
                                case Settings.SendShortCut.CtrlEnter:
                                    {
                                        if (event.modifiers & Qt.ControlModifier) {
                                            d.sendMessage();
                                        } else {
                                            messengerInput.appendNewLine();
                                        }
                                        event.accepted = true;
                                        return;
                                    }
                                case Settings.SendShortCut.Enter:
                                    {
                                        if (event.modifiers === Qt.NoModifier) {
                                            d.sendMessage();
                                        } else {
                                            messengerInput.appendNewLine();
                                        }
                                        event.accepted = true;
                                        return;
                                    }
                                case Settings.SendShortCut.ButtonOnly:
                                    {
                                        messengerInput.appendNewLine();
                                        event.accepted = true;
                                        return;
                                    }
                                }
                                event.accepted = false;
                            }

                            Keys.onEscapePressed: root.closeDialogPressed();

                            onTextChanged: {
                                composingTimer.count = 0;
                                if (text.length <= 0) {
                                    d.setActiveStatus(MessengerJs.selectedUser(), "Active");
                                    composingTimer.stop();
                                } else {
                                    d.setActiveStatus(MessengerJs.selectedUser(), "Composing");
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
                                    d.setActiveStatus(MessengerJs.selectedUser(), "Inactive");
                                    return;
                                }

                                if (composingTimer.count >= root.pauseTimeout) {
                                    d.setActiveStatus(MessengerJs.selectedUser(), "Paused");
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
                        normal: Styles.style.messengerMessageInputSendButtonNormal
                        hover: Styles.style.messengerMessageInputSendButtonHover
                    }

                    onClicked: d.sendMessage()
                    text: qsTr("MESSENGER_SEND_BUTTON")
                    textColor: Styles.style.messengerMessageInputSendButtonText
                }

                Text {
                    function getText() {
                        switch(root.sendAction){
                        case Settings.SendShortCut.Enter:
                            return qsTr("MESSENGER_SEND_BUTTON_MESSAGE_ENTER");
                        case Settings.SendShortCut.CtrlEnter:
                            return qsTr("MESSENGER_SEND_BUTTON_MESSAGE_CTRL_ENTER");
                        case Settings.SendShortCut.ButtonOnly:
                            return "";
                        }

                        return "";
                    }

                    anchors.horizontalCenter: parent.horizontalCenter

                    color: Styles.style.messengerMessageInputSendHotkeyText
                    text: getText()
                }
            }
        }
    }
}
