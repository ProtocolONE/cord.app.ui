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
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0
import Tests.Application.Core.Fixtures.Popup.Sample 1.0

import "../../../Application/Core/MessageBox.js" as MessageBox
import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/App.js" as AppJs


Item {
    width: 1000
    height: 599

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.AlertAdapter');
            manager.registerWidget('Application.Widgets.Maintenance');
            manager.registerWidget('Application.Widgets.Facts');
            manager.registerWidget('Tests.Application.Core.Fixtures.Popup.Sample');
            manager.init();

            AppJs.activateGame(AppJs.serviceItemByGameId("92"));
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Assets/Images/test/main_07.png'
        }
    }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageBoxLayer

        anchors.fill: parent
        z: 3
    }

    // Initialization

    Component.onCompleted: {
        Settings.setValue("qml/core/popup/", "isHelpShowed", 0);
        Popup.init(popupLayer);
        MessageBox.init(messageBoxLayer);
    }

    // Test Buttons

    Row {
        z: 3

        spacing: 3

        Button {
            width: 200
            height: 30

            text: "Maintenance"

            onClicked: Popup.show("Maintenance");
        }

        Button {
            width: 200
            height: 30

            text: "Facts"

            onClicked: Popup.show("Facts");
        }

        Button {
            width: 200
            height: 30

            text: "SomeWidget"

            onClicked: Popup.show("Sample");
        }

        Button {
            width: 200
            height: 30

            text: "SomeWidget (priority 1)"

            onClicked: Popup.show("Sample", undefined, 1);
        }

        Button {
            width: 200
            height: 30

            text: "MessageBox"

            onClicked: MessageBox.show("этот очень замечательный заголовок",
                                        "Какой то очень длинный длинный текст раз два три четыре, я ты он она, вместе дружная семья!",
                                        MessageBox.button["Ok"] | MessageBox.button["Cancel"] | MessageBox.button["Yes"], function(result) {
             });

        }
    }
}
