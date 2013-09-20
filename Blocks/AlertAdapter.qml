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
import "../Elements" as Elements
import "../Proxy/AppProxy.js" as AppProxy

Item {
    id: page

    anchors.fill: parent

    property variant _buttonMesages
    signal alertShown();

    function addMessage(text, title, buttons, callback) {
        var comp = d.emitMessage(text, title, buttons, 0, 100500);
        comp.clicked.connect(callback);
    }

    QtObject {
        id: d

        function emitMessage(text, title, buttons, icon, messageId) {
            var lastButton,
                buttonCount = 0,
                comp = alertMessage.createObject(page,
                                                 {
                                                    messageText: text,
                                                    headerTitle: title
                                                 });

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

            return comp;
        }
    }

    Component.onCompleted: {

        var result = {};



        result[AppProxy.Message.Ok] = qsTr("OK");
        result[AppProxy.Message.Save] = qsTr("Save");
        result[AppProxy.Message.SaveAll] = qsTr("SaveAll");
        result[AppProxy.Message.Open] = qsTr("Open");
        result[AppProxy.Message.Yes] = qsTr("Yes");
        result[AppProxy.Message.YesToAll] = qsTr("YesToAll");
        result[AppProxy.Message.No] = qsTr("No");
        result[AppProxy.Message.NoToAll] = qsTr("NoToAll");
        result[AppProxy.Message.Abort] = qsTr("Abort");
        result[AppProxy.Message.Retry] = qsTr("Retry");
        result[AppProxy.Message.Ignore] = qsTr("Ignore");
        result[AppProxy.Message.Close] = qsTr("Close");
        result[AppProxy.Message.Cancel] = qsTr("Cancel");
        result[AppProxy.Message.Discard] = qsTr("Discard");
        result[AppProxy.Message.Help] = qsTr("Help");
        result[AppProxy.Message.Apply] = qsTr("Apply");
        result[AppProxy.Message.Reset] = qsTr("Reset");
        result[AppProxy.Message.RestoreDefaults] = qsTr("RestoreDefaults");

        _buttonMesages = result;
    }

    Component {
        id: alertMessage

        Elements.AlertMessage {

            signal enterClicked(int buttonId);

            focus: visible

            Keys.onEnterPressed: enterClicked(AppProxy.Message.Ok);
            Keys.onReturnPressed: enterClicked(AppProxy.Message.Ok);
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
            var comp = d.emitMessage(text, title, buttons, icon, messageId);
            messageBox.bindSlot(comp, messageId);
        }
    }
}
