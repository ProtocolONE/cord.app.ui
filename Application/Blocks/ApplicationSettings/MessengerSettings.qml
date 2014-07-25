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
import Application.Controls 1.0 as ApplicationControls
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../GameNet/Components/Widgets/WidgetManager.js" as WidgetManager
import "../../Widgets/Messenger/Models/Settings.js" as MessengerSettings

Item {
    id: root

    property variant settingsViewModelInstance: App.settingsViewModelInstance() || {}

    function load(){
        var settings = WidgetManager.getWidgetSettings('Messenger');
        d.currentSendOption = settings.sendAction;
    }

    function save() {
        var settings = WidgetManager.getWidgetSettings('Messenger');
        settings.sendAction = d.currentSendOption;
        settings.save();
    }

    QtObject {
        id: d

        property int currentSendOption: MessengerSettings.SendShortCut.Enter
    }

    Column {
        x: 30
        spacing: 15

        Text {
            width: parent.width
            height: 20
            text: qsTr("MESSENGER_SEND_ACTION_TITLE")
            font {
                family: 'Arial'
                pixelSize: 16
            }
            color: '#5c6d7d'
        }

        RadioButton {
            id: sendOnEnter

            property int optionValue: MessengerSettings.SendShortCut.Enter

            fontSize: 15
            text: qsTr("MESSENGER_SEND_ON_ENTER")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }

        RadioButton {
            id: sendOnCtrlEnter

            property int optionValue: MessengerSettings.SendShortCut.CtrlEnter

            width: parent.width
            height: 20
            fontSize: 15
            text: qsTr("MESSENGER_SEND_ON_CTRL_ENTER")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }

        RadioButton {
            id: sendOnButton

            property int optionValue: MessengerSettings.SendShortCut.ButtonOnly

            width: parent.width
            height: 20
            fontSize: 15
            text: qsTr("MESSENGER_SEND_ON_BUTTON")
            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
            }
            checked: d.currentSendOption === optionValue
            onClicked: d.currentSendOption = optionValue;
        }
    }
}
