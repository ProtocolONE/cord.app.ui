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

import Application.Controls 1.0 as ApplicationControls
import Application.Blocks.Settings 1.0

import "../../../Core/App.js" as App

import "../../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../../GameNet/Components/Widgets/WidgetManager.js" as WidgetManager
import "../../../Widgets/Messenger/Models/Settings.js" as MessengerSettings

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
    }

    function save() {
        var settings = WidgetManager.getWidgetSettings('Messenger');
        settings.sendAction = d.currentSendOption;
        settings.historySaveInterval = messengerHistoryInterval.getValue(messengerHistoryInterval.currentIndex);
        settings.save();
    }

    QtObject {
        id: d

        property int currentSendOption: MessengerSettings.SendShortCut.Enter
    }

    Column {
        x: 30
        width: parent.width
        spacing: 15

        Row {
            height: 40
            z: 1
            spacing: 10

            SettingsCaption {
                y: 9
                width: 140
                text: qsTr("MESSENGER_HISTORY_SAVE_COMBOBOX_TITLE")
            }

            ApplicationControls.ComboBox {
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

            SettingsButton {
                width: 180
                height: 40

                fontSize: 14
                text: qsTr("HISTORY_CLEAR_BUTTON")
                onClicked: {
                    var widget = WidgetManager.getWidgetByName('Messenger');
                    widget.model.clearHistory();
                }
            }
        }

        SettingsCaption {
            text: qsTr("MESSENGER_SEND_ACTION_TITLE")
        }

        SettingsRadioButton {
            id: sendOnEnter

            property int optionValue: MessengerSettings.SendShortCut.Enter

            text: qsTr("MESSENGER_SEND_ON_ENTER")
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }

        SettingsRadioButton {
            id: sendOnCtrlEnter

            property int optionValue: MessengerSettings.SendShortCut.CtrlEnter

            text: qsTr("MESSENGER_SEND_ON_CTRL_ENTER")
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }

        SettingsRadioButton {
            id: sendOnButton

            property int optionValue: MessengerSettings.SendShortCut.ButtonOnly

            text: qsTr("MESSENGER_SEND_ON_BUTTON")
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }




    }
}
