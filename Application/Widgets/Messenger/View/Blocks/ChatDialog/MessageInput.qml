import QtQuick 2.4
import Tulip 1.0

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import Application.Controls 1.0

import Application.Core 1.0
import Application.Core.Styles 1.0
import Application.Widgets.Messenger.Addons 1.0

import "../../../Models/Messenger.js" as MessengerJs
import "../../../Models/Settings.js" as Settings


FocusScope {
    id: root

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

    function getPlainTextLength() {
        return TextDocumentHelper.stripHtml(messengerInput.text).length;
    }

    function setMessage(message) {
        d.setCurrentEditMessage(message);
    }

    function makeQuoteMessage(message, clear) {

        if (clear)
            messengerInput.text = "";

        var quoteProcessing = new Quote.QuoteProcessing(MessageHelper.replaceNewLines(message), tempInput, function(text) {

            if (messengerInput.selectionStart < messengerInput.selectionEnd) {
                messengerInput.remove(messengerInput.selectionStart, messengerInput.selectionEnd);
            }

            if (!clear && messengerInput.selectionStart > 0) {
                text = "\n" + text;
            }

            messengerInput.insert(messengerInput.selectionStart, MessageHelper.replaceNewLines(text));
        }, { quoteAuthorColor: Styles.messengerQuoteAuthorColor, installPath: installPath });
    }

    function setQuote(messageItem, message) {
        var text = messageItem.getSelectedText();
        if (text.length === 0)
            text = Quote.removeQuote(message.text);
        var quote = Quote.makeQuote(text, MessengerJs.getNickname(message), message.date);
        makeQuoteMessage(quote + "\n\n", false);
    }

    QtObject {
        id: d

        property string activeStatus: "Active"
        property int editMessageCounter: -1
        property var messageModel
        property string xmppId: ""
        property bool isGroup: false

        function userChanged() {
            d.editMessageCounter = -1;
            var selUser = MessengerJs.selectedUser();
            if (selUser.isValid()) {
                var conversation = MessengerJs.getConversation(selUser.jid);
                d.messageModel = conversation.messages;
                d.isGroup = conversation.type == 3;
            }
        }

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

        function isModelValid() {
            var result = true;

            // Check model ok
            if (!d.messageModel && d.messageModel.count == 0) {
                result = false;
            }

            return result;
        }

        function getCurrentItem() {
            var messageItem = d.messageModel.get(d.editMessageCounter);
            return messageItem;
        }

        function clearInputHistory() {
            if (d.editMessageCounter == -1) {
                return;
            }

            // Check model ok
            if (!d.isModelValid()) {
                return;
            }

            var messageItem = getCurrentItem();
            messageItem.editTmpMesage = "";
        }

        function clearInput() {
            messengerInput.text = "";
            d.setActiveStatus(MessengerJs.selectedUser(), "Active");
            d.editMessageCounter = -1;
            d.xmppId = "";
            editBackgroundColor.color = Styles.dark;

            Quote.clearQuoteCache();
        }

        function setCurrentEditMessage(message) {
            // Check message time
            if (!messengerInput.isMessageTimeValid(message)) 
                return;

            makeQuoteMessage(message.text, true);

            d.setActiveStatus(MessengerJs.selectedUser(), "Active");
            d.xmppId = message.messageId;
            d.editMessageCounter = -1;
        }

        function sendMessage() {
            if (!d.canSendMessage()) {
                return;
            }

            if (d.validateMessage(messengerInput.text)) {
                var convertedText = EmojiOne.ns.htmlToShortname(messengerInput.text);
                convertedText = Quote.htmlToQuote(convertedText);
                convertedText = TextDocumentHelper.stripHtml(convertedText);

                MessengerJs.getConversation(MessengerJs.selectedUser().jid)
                    .writeMessage(convertedText, d.xmppId);

                d.clearInputHistory();
                d.clearInput();
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
            var user = MessengerJs.previousUser(),
                plainLenth = getPlainTextLength();

            if (user.isValid()) {
                d.setActiveStatus(user, "Active");

                if (plainLenth > 0) {
                    user.inputMessage = messengerInput.text;
                }
            }

            user = MessengerJs.selectedUser();
            if (user.isValid()) {
                messengerInput.text = user.inputMessage;
                user.inputMessage = "";
                messengerInput.cursorPosition = plainLenth;
            }
        }

        function validateMessage(msg) {
            //  INFO: стандарт не предусматривает ограничение длины сообщения, но на момент 17.12.2014
            //  на наших серверах стоит ограничение 64кб на станзу (это с учетом служебной инфы)
            //  Поэтому, решено сделать ограничение 32кб на длину самого сообщения
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
                && !MessengerJs.isSelectedProtocolOne();
        }

        function canEditMessage() {
            return !MessengerJs.editGroupModel().isActive() && !MessengerJs.isSelectedProtocolOne();
        }
    }

    Connections {
        target: MessengerJs.instance()
        onSelectedUserChanged: {
            d.updateUserSelectedText();
            d.userChanged();
        }
    }

    Rectangle { // split sign
        width: 4
        height: 4
        border { color: Styles.light }
        opacity: 0.35
        color: '#00000000'
        radius: 2
        anchors { top: parent.top; topMargin: 2; left: parent.left; leftMargin: 10 + (parent.width - 110) / 2 }
    }

    Row {
        anchors {
            fill: parent
            topMargin: 10
            leftMargin: 110
            bottomMargin: 12
            rightMargin: 12
        }

        spacing: 8

        Item {
            height: parent.height
            width: parent.width - 98

            Rectangle {

                id: editBackgroundColor

                anchors.fill: parent
                color: Styles.dark
                opacity: 0.2
            }

            Item {
                anchors {
                    fill: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: messengerInput.forceActiveFocus();

                    Item {
                        anchors {
                            fill: parent
                            leftMargin: 10
                            topMargin: 10
                            bottomMargin: 10
                            rightMargin: 28
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
                                TextEdit {
                                    id: tempInput
                                    visible: false
                                    textFormat: TextEdit.RichText
                                    color: Styles.chatButtonText
                                }
                                id: messengerInput

                                function appendNewLine() {
                                    root.insertText("<br />");
                                }

                                function dropCounter() {
                                    // Check message cursor
                                    if (d.editMessageCounter == -1) {
                                        // Not inited cursor
                                        d.editMessageCounter = d.messageModel.count - 1;
                                    }
                                }

                                function isMessageTimeValid(messageItem) {
                                    var result = false;

                                    var diff = (Date.now() - messageItem.date)/1000;

                                    if (diff <= 1800) { // 30 minutes to go
                                        result = true;
                                    }

                                    return result;
                                }

                                function updateText(messageItem) {
                                    d.xmppId = messageItem.messageId;

                                    if (messageItem.editTmpMesage !== "") {
                                        makeQuoteMessage(messageItem.editTmpMesage, true);
                                    } else {
                                        makeQuoteMessage(messageItem.text, true);
                                    }

                                    editBackgroundColor.color = Styles.editMessageSelected;
                                }

                                function getNextItem() {
                                    var i;
                                    var jabber = MessengerJs.instance().getJabberClient();

                                    if (jabber === null)
                                        return null;

                                    for (i = d.editMessageCounter; i >= 0; i--) {
                                        var messageItem = d.messageModel.get(i);

                                        d.editMessageCounter--;

                                        // Check message time
                                        if (!isMessageTimeValid(messageItem)) {
                                            break;
                                        }

                                        // Skip not sended with us
                                        if (messageItem.jid !== jabber.myJid)
                                            continue;

                                        return messageItem;
                                    }

                                    // In case we iterated through all sended to us messages
                                    d.editMessageCounter = -1;

                                    return null;
                                }

                                function updateTempInput() {
                                    if (d.editMessageCounter == (d.messageModel.count - 1)) {
                                        // Detect first up arrow
                                        // Input in this case is empty
                                        return;
                                    }

                                    var messageItem = d.messageModel.get(d.editMessageCounter + 1);

                                    // Detect text change - if found then remember
                                    var convertedText = EmojiOne.ns.htmlToShortname(messengerInput.text);
                                    convertedText = Quote.htmlToQuote(convertedText);
                                    convertedText = TextDocumentHelper.stripHtml(convertedText);

                                    if (convertedText !== "") {
                                        if (convertedText !== messageItem.text) {
                                            // Remeber current edit text
                                            messageItem.editTmpMesage = convertedText;
                                        }
                                    }

                                }

                                function allowEditNext() {
                                    var result = true;

                                    if (messengerInput.cursorPosition != 0) {
                                        messengerInput.cursorPosition = 0;
                                        result = false;
                                    }

                                    return result;
                                }

                                width: inputFlick.width
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

                                color: Styles.chatButtonText
                                onCursorRectangleChanged: inputFlick.ensureVisible(cursorRectangle);

                                Keys.onPressed: {
                                    if ((event.key === Qt.Key_Insert) && (event.modifiers === Qt.ShiftModifier) ||
                                        (event.key === Qt.Key_V) && (event.modifiers === Qt.ControlModifier)) {
                                        if (messengerInput.canPaste && (ClipboardAdapter.hasText() || ClipboardAdapter.hasQuote())) {

                                            if (ClipboardAdapter.hasQuote()) {
                                                var quote = ClipboardAdapter.quote();
                                                makeQuoteMessage(quote + "\n\n", false);
                                                Ga.trackEvent('MessageInput', 'quote', 'insert');

                                            }
                                            else {
                                                if (messengerInput.selectionStart < messengerInput.selectionEnd)
                                                    messengerInput.remove(messengerInput.selectionStart, messengerInput.selectionEnd);

                                                var text = MessageHelper.escapeHtml(ClipboardAdapter.text());
                                                messengerInput.insert(messengerInput.selectionStart, MessageHelper.replaceNewLines(text));
                                            }
                                        }
                                        event.accepted = true;
                                    }
                                }

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

                                Keys.onEscapePressed: {
                                    if (d.xmppId !== "") {
                                        d.clearInputHistory();
                                        d.clearInput();
                                        return;
                                    }

                                    root.closeDialogPressed();
                                }

                                Keys.onUpPressed: {
                                    // Disable on group chats
                                    if(d.isGroup)
                                        return;

                                    // Check model ok
                                    if (!d.isModelValid())
                                        return;

                                    // Drop cursor if needed
                                    dropCounter();

                                    // Check cursor position
                                    if(!allowEditNext())
                                        return;

                                    updateTempInput();

                                    var messageItem = getNextItem();

                                    if (messageItem === null) {
                                        return;
                                    }

                                    updateText(messageItem);
                                    Ga.trackEvent('MessageInput', 'editMessage', 'edit');
                                }

                                onTextChanged: {
                                    var plainLength = getPlainTextLength();

                                    composingTimer.count = 0;
                                    if (plainLength <= 0) {
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

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.NoButton
                    cursorShape: Qt.IBeamCursor
                }
            }

            ContentThinBorder {}
        }

        Item {
            width: 90
            height: parent.height

            Column {
                anchors.fill: parent
                spacing: 10

                CheckedButton {
                    id: sendMessageButton

                    width: parent.width
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

                    color: Styles.textBase
                    text: getText()
                }
            }
        }
    }
}
