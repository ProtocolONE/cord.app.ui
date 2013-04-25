/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import qGNA.Library 1.0

import "../Elements" as Elements

Item {
    id: page

    anchors.fill: parent

    property variant _buttonMesages
    signal alertShown();

    Component.onCompleted: {

        var result = {};

        result[Message.Ok] = qsTr("OK");
        result[Message.Save] = qsTr("Save");
        result[Message.SaveAll] = qsTr("SaveAll");
        result[Message.Open] = qsTr("Open");
        result[Message.Yes] = qsTr("Yes");
        result[Message.YesToAll] = qsTr("YesToAll");
        result[Message.No] = qsTr("No");
        result[Message.NoToAll] = qsTr("NoToAll");
        result[Message.Abort] = qsTr("Abort");
        result[Message.Retry] = qsTr("Retry");
        result[Message.Ignore] = qsTr("Ignore");
        result[Message.Close] = qsTr("Close");
        result[Message.Cancel] = qsTr("Cancel");
        result[Message.Discard] = qsTr("Discard");
        result[Message.Help] = qsTr("Help");
        result[Message.Apply] = qsTr("Apply");
        result[Message.Reset] = qsTr("Reset");
        result[Message.RestoreDefaults] = qsTr("RestoreDefaults");

        _buttonMesages = result;
    }

    Component {
        id: alertMessage

        Elements.AlertMessage {

            signal enterClicked(int buttonId);

            focus: visible

            Keys.onEnterPressed: enterClicked(Message.Ok);
            Keys.onReturnPressed: enterClicked(Message.Ok);
        }
    }

    Component {
        id: buttonComponent

        Elements.Button2 { }
    }

    Connections {
        id: messageConnections

        target: messageBox

        function getButtonText(ident) {
            return _buttonMesages[ident] || qsTr("Default Text");
        }

        function addButton(button, messageId, comp) {
            var newButton = buttonComponent.createObject(comp.controlRow,
                                         {
                                               buttonId: button,
                                               messageId: messageId,
                                               buttonText: getButtonText(button),
                                         });

            newButton.clicked.connect(comp.clicked);
            newButton.buttonClicked.connect(comp.buttonClicked);

            return newButton;
        }


        onEmitMessage: {
            var lastButton,
                buttonCount = 0,
                comp = alertMessage.createObject(page,
                                                 {
                                                    messageText: text,
                                                    headerTitle: title
                                                 });

            messageBox.bindSlot(comp, messageId);

            for (var button in page._buttonMesages) {
                if ((buttons & button) == button) {
                    ++buttonCount;
                    lastButton = messageConnections.addButton(button, messageId, comp);
                }
            }

            if (buttonCount < 2) {
                comp.enterClicked.connect(lastButton.clicked);
            }

            page.alertShown();
        }
    }
}
