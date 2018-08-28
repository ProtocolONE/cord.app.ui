import QtQuick 2.4

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0 as Controls

import Application.Core 1.0
import Application.Core.MessageBox 1.0

WidgetModel {
    id: root

    signal displayView(variant message);
    signal callback(int button);

    signal blink();

     Component.onCompleted: {
        MessageBox.registerModel(root);

        var result = {};
        result[MessageBox.button['ok']] = qsTr("OK");
        result[MessageBox.button['save']] = qsTr("Save");
        result[MessageBox.button['saveAll']] = qsTr("SaveAll");
        result[MessageBox.button['open']] = qsTr("Open");
        result[MessageBox.button['yes']] = qsTr("Yes");
        result[MessageBox.button['yesToAll']] = qsTr("YesToAll");
        result[MessageBox.button['no']] = qsTr("No");
        result[MessageBox.button['noToAll']] = qsTr("NoToAll");
        result[MessageBox.button['abort']] = qsTr("Abort");
        result[MessageBox.button['retry']] = qsTr("Retry");
        result[MessageBox.button['ignore']] = qsTr("Ignore");
        result[MessageBox.button['close']] = qsTr("Close");
        result[MessageBox.button['cancel']] = qsTr("Cancel");
        result[MessageBox.button['discard']] = qsTr("Discard");
        result[MessageBox.button['help']] = qsTr("Help");
        result[MessageBox.button['apply']] = qsTr("Apply");
        result[MessageBox.button['reset']] = qsTr("Reset");
        result[MessageBox.button['support']] = qsTr("Support");
        result[MessageBox.button['restoreDefaults']] = qsTr("RestoreDefaults");

        MessageBox.setButtonNames(result);
    }

    function activate(message) {
        root.displayView(message);
    }

    Connections {
        target: App.messageBoxInstance()
        ignoreUnknownSignals: true

        onEmitMessage: {
            var id = messageId;

            MessageBox.show(title, text, buttons, function(button) {
                messageBox.callback(id, button);
            });
        }
    }
}
