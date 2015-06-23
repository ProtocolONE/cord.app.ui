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
import GameNet.Controls 1.0

import Application.Controls 1.0

import "../../../../Core/App.js" as App

import "../../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../../GameNet/Components/Widgets/WidgetManager.js" as WidgetManager
import "../../../Messenger/Models/Settings.js" as MessengerSettings

Item {
    id: root

    property variant settingsViewModelInstance: App.settingsViewModelInstance() || {}

    function load(){
        var settings = WidgetManager.getWidgetSettings('Messenger');
        d.currentSendOption = settings.sendAction;

        var historyValue = messengerHistoryInterval.findValue(settings.historySaveInterval);
        if (historyValue == -1) {
            historyValue = messengerHistoryInterval.findValue("0");
        }

        messengerHistoryInterval.currentIndex = historyValue;

        var overlaySettings = WidgetManager.getWidgetSettings('Overlay'),
            overlayChatOpenHotkey = messengerOverlayHotkey.findValue(overlaySettings.messengerOpenChatHotkey);

        if (overlayChatOpenHotkey == -1) {
            overlayChatOpenHotkey = 0;
        }       

        messengerOverlayHotkey.currentIndex = overlayChatOpenHotkey;
        messengerShowChatOverlayNotify.checked = overlaySettings.messengerShowChatOverlayNotify;
    }

    function save() {
        var settings = WidgetManager.getWidgetSettings('Messenger');
        settings.sendAction = d.currentSendOption;
        settings.historySaveInterval = messengerHistoryInterval.getValue(messengerHistoryInterval.currentIndex);
        settings.save();

        var overlaySettings = WidgetManager.getWidgetSettings('Overlay');
        overlaySettings.messengerOpenChatHotkey = messengerOverlayHotkey.getValue(messengerOverlayHotkey.currentIndex);
        overlaySettings.messengerShowChatOverlayNotify = messengerShowChatOverlayNotify.checked;
        overlaySettings.save();
    }

    function reset() {
        var overlayChatOpenHotkey = messengerOverlayHotkey.findValue(JSON.stringify({key: Qt.Key_Backtab, name: "Shift + Tab"}));

        d.currentSendOption = MessengerSettings.SendShortCut.Enter;
        messengerHistoryInterval.currentIndex = messengerHistoryInterval.findValue("0");
        messengerOverlayHotkey.currentIndex = overlayChatOpenHotkey;
        messengerShowChatOverlayNotify.checked = true;
    }

    QtObject {
        id: d

        property int currentSendOption: MessengerSettings.SendShortCut.Enter
    }

    Column {
        width: parent.width
        spacing: 15

        Row {
            height: 40
            z: 2
            spacing: 10

            SettingsCaption {
                anchors.verticalCenter: parent.verticalCenter
                width: 215
                font {
                    pixelSize: 14
                }

                text: qsTr("MESSENGER_HISTORY_SAVE_COMBOBOX_TITLE")
            }

            ComboBox {
                id: messengerHistoryInterval

                width: 200
                height: 40

                Component.onCompleted: {
                    // value должен понимать Moment, в формате (Number, String)
                    // array = value.split(' ');
                    // date = moment().substract(array[0], array[1]);

                    append("0", qsTr("HISTORY_SAVE_ALLWAYS"));
                    append("3 month", qsTr("HISTORY_SAVE_3_MONTH"));
                    append("2 month", qsTr("HISTORY_SAVE_TWO_MONTH"));
                    append("1 month", qsTr("HISTORY_SAVE_ONE_MONTH"));
                    append("2 week", qsTr("HISTORY_SAVE_TWO_WEEKS"));
                    append("-1", qsTr("HISTORY_DONT_SAVE"));
                }
            }

            MinorButton {
                width: 180
                height: 40

                text: qsTr("HISTORY_CLEAR_BUTTON")
                onClicked: {
                    var widget = WidgetManager.getWidgetByName('Messenger');
                    widget.model.clearHistory();
                }
            }
        }

        Row {
            height: 40
            z: 1
            spacing: 10

            SettingsCaption {
                anchors.verticalCenter: parent.verticalCenter
                width: 215
                text: qsTr("MESSENGER_OPEN_CHAT_TITLE")
                font {
                    pixelSize: 14
                }
            }

            ComboBox {
                id: messengerOverlayHotkey

                width: 200
                height: 40

                Component.onCompleted: {
                    append(JSON.stringify({key: Qt.Key_Backtab, name: "Shift + Tab"}), "Shift + Tab");
                    append(JSON.stringify({key: Qt.Key_Tab, modifiers: Qt.ControlModifier, name: "Ctrl + Tab"}), "Ctrl + Tab");
                }
            }
        }

        CheckBox {
            id: messengerShowChatOverlayNotify

            text: qsTr("MESSENGER_SHOW_CHAT_NOTIFY_IN_OVERLAY")
        }

        Item {
            width: 10
            height: 10
        }

        SettingsCaption {
            text: qsTr("MESSENGER_SEND_ACTION_TITLE")
            font.pixelSize: 14
        }

        RadioButton {
            id: sendOnEnter

            property int optionValue: MessengerSettings.SendShortCut.Enter

            text: qsTr("MESSENGER_SEND_ON_ENTER")
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }

        RadioButton {
            id: sendOnCtrlEnter

            property int optionValue: MessengerSettings.SendShortCut.CtrlEnter

            text: qsTr("MESSENGER_SEND_ON_CTRL_ENTER")
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }

        RadioButton {
            id: sendOnButton

            property int optionValue: MessengerSettings.SendShortCut.ButtonOnly

            text: qsTr("MESSENGER_SEND_ON_BUTTON")
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }
    }
}
