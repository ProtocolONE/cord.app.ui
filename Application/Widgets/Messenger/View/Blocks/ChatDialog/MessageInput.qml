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

import "../../../../../Core/EmojiOne.js" as EmojiOne

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

    function appendText(text) {
        var actualFormattedText = d.getPlainText();

        messengerInput.textFormat = TextEdit.PlainText;
        messengerInput.text = actualFormattedText + text;
        messengerInput.textFormat = TextEdit.RichText;
    }

    function insertText(text) {
        var actualFormattedText,
            oldCursorPosition,
            insertPosition,
            leftPad,
            rightPad;

        actualFormattedText = d.getPlainText();

        oldCursorPosition = messengerInput.cursorPosition;
        insertPosition = d.getInsertPosition(messengerInput.cursorPosition, actualFormattedText);
        leftPad = actualFormattedText.substring(0, insertPosition);
        rightPad = actualFormattedText.substring(insertPosition, actualFormattedText.length);

        messengerInput.textFormat = TextEdit.PlainText;
        messengerInput.text = leftPad + EmojiOne.ns.toImage(text) + rightPad;
        messengerInput.textFormat = TextEdit.RichText;
        messengerInput.cursorPosition = oldCursorPosition + 1;
    }

    QtObject {
        id: d

        property string activeStatus: "Active"
        property string plainText: TextDocumentHelper.stripHtml(messengerInput.text)

        function getPlainText() {
            var temporaryModifiedImgTag,
                    actualText,
                    actualFormattedText;

            temporaryModifiedImgTag = messengerInput.text.replace(/<img\s+([^>]+)>/gi, function(attr) {
                return '[' + attr.substring(1, attr.length - 2) + ']';
            });

            temporaryModifiedImgTag = temporaryModifiedImgTag.replace(/<br [/]>/gi, "[br /]");

            actualText = TextDocumentHelper.stripHtml(temporaryModifiedImgTag);

            actualFormattedText = actualText.replace(/\[img\s+([^\]]+)\]/gi, function(attr) {
                return '<' + attr.substring(1, attr.length - 2) + '>';
            });

            actualFormattedText = actualFormattedText.replace(/\[br \/\]/gi, "<br />");

            return actualFormattedText;
        }

        function getInsertPosition(pos, shortArray) {
            var i,
                    result = 0,
                    html = shortArray,
                    imgPosition = {},
            regExp = /<img\s+([^>]+)>/gi,
                    found;

            while (found = regExp.exec(html)) {
                imgPosition[+found.index] = regExp.lastIndex;
            }

            regExp = /<br [/]>/gi;

            while (found = regExp.exec(html)) {
                imgPosition[+found.index] = regExp.lastIndex;
            }

            for (i = 0; i < html.length; result++) {
                if (result == pos) {
                    return i;
                }

                if (imgPosition.hasOwnProperty(i)) {
                    i += (imgPosition[i] - i);
                } else {
                    i++;
                }
            }

            return i;
        }

        function sendMessage() {
            if (!d.canSendMessage()) {
                return;
            }

            if (d.validateMessage(messengerInput.text)) {
                var convertedText = EmojiOne.ns.htmlToShortname(messengerInput.text);
                convertedText = TextDocumentHelper.stripHtml(convertedText);

                MessengerJs.getConversation(MessengerJs.selectedUser().jid)
                    .writeMessage(convertedText);

                messengerInput.text = "";
                d.setActiveStatus(MessengerJs.selectedUser(), "Active");
            }
        }

        function setActiveStatus(user, status) {
            if (d.activeStatus === status) {
                return;
            }

            d.activeStatus = status;

            MessengerJs.getConversation(user.jid)
                .setTypingState(status);
        }

        function updateUserSelectedText() {
            var user = MessengerJs.previousUser();

            if (user.isValid()) {
                d.setActiveStatus(user, "Active");

                if (d.plainText.length > 0) {
                    user.inputMessage = messengerInput.text;
                }
            }

            user = MessengerJs.selectedUser();
            if (user.isValid()) {
                messengerInput.text = user.inputMessage;
                user.inputMessage = "";
                messengerInput.cursorPosition = d.plainText.length;
            }
        }

        function validateMessage(msg) {
            //  INFO: стандарт не предусматривает ограничение длины сообщения, но на момент 17.12.2014
            //  на наших серверах стоит ограничение 64кб на станзу (это с учетом служебной инфы)
            //  Поэтому, в рамках QGNA-1117 решено сделать ограничение 32кб на длину самого сообщения
            //  Ссылки по теме:
            //      - http://xmpp.org/extensions/xep-0205.html#rec-stanzasize
            //      - http://www.xmpp.org/extensions/inbox/stanzalimits.html
            msg = TextDocumentHelper.stripHtml(msg);

            if (msg.length > 32768) {
                return false;
            }

            var replaced = msg.replace(/\s/g, "");
            return replaced.length > 0;
        }

        function canSendMessage() {
            return MessengerJs.getStatus() === MessengerJs.ROSTER_RECEIVED
                && !MessengerJs.editGroupModel().isActive()
        }

        function canEditMessage() {
            return !MessengerJs.editGroupModel().isActive();
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

                MouseArea {
                    anchors.fill: parent
                    onClicked: messengerInput.forceActiveFocus();

                    Item {
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
                                    root.appendText("<br />");
                                    messengerInput.cursorPosition = d.plainText.length;
                                }

                                width: inputFlick.width - 18
                                height: inputFlick.height
                                focus: true
                                textFormat: TextEdit.RichText

                                selectByMouse: true
                                wrapMode: TextEdit.Wrap
                                readOnly: !d.canEditMessage()

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
                                    if (d.plainText.length <= 0) {
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

                CursorArea {
                    anchors.fill: parent
                    cursor: CursorArea.IBeamCursor
                }
            }
        }

        Item {
            width: 100
            height: parent.height

            Column {
                anchors.fill: parent
                spacing: 10

                CheckedButton {
                    id: sendMessageButton

                    width: 89
                    height: 30
                    boldBorder: true
                    enabled: d.canSendMessage();
                    checked: sendMessageButton.enabled
                    text: qsTr("MESSENGER_SEND_BUTTON")
                    onClicked: d.sendMessage()
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
