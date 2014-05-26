/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0 as Controls
import "../../../js/restapi.js" as RestApi
import "../../../js/Core.js" as Core
import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/MessageBox.js" as MessageBox

WidgetModel {
    id: root

    signal displayView(variant message);
    signal callback(int button);

    signal blink();

     Component.onCompleted: {
        MessageBox.registerModel(root);

        var result = {};
        result[MessageBox.button['Ok']] = qsTr("OK");
        result[MessageBox.button['Save']] = qsTr("Save");
        result[MessageBox.button['SaveAll']] = qsTr("SaveAll");
        result[MessageBox.button['Open']] = qsTr("Open");
        result[MessageBox.button['Yes']] = qsTr("Yes");
        result[MessageBox.button['YesToAll']] = qsTr("YesToAll");
        result[MessageBox.button['No']] = qsTr("No");
        result[MessageBox.button['NoToAll']] = qsTr("NoToAll");
        result[MessageBox.button['Abort']] = qsTr("Abort");
        result[MessageBox.button['Retry']] = qsTr("Retry");
        result[MessageBox.button['Ignore']] = qsTr("Ignore");
        result[MessageBox.button['Close']] = qsTr("Close");
        result[MessageBox.button['Cancel']] = qsTr("Cancel");
        result[MessageBox.button['Discard']] = qsTr("Discard");
        result[MessageBox.button['Help']] = qsTr("Help");
        result[MessageBox.button['Apply']] = qsTr("Apply");
        result[MessageBox.button['Reset']] = qsTr("Reset");
        result[MessageBox.button['RestoreDefaults']] = qsTr("RestoreDefaults");

        MessageBox.buttonNames = result;
    }

    function activate(message) {
        root.displayView(message);
    }

    Connections {
        target: messageBox

        onEmitMessage: {
            var id = messageId;

            MessageBox.show(title, text, buttons, function(button) {
                messageBox.callback(id, button);
            });
        }
    }
}
