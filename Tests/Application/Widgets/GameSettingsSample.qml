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

import Application 1.0

import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0


import "../../../Application/Core/App.js" as App
import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/MessageBox.js" as MessageBoxJs
import "../../../GameNet/Controls/Tooltip.js" as Tooltip

Rectangle {
    width: 1000
    height: 600
    color: '#EEEEEE'

    Component.onCompleted: {
        Popup.init(popupLayer);
        MessageBoxJs.init(messageboxLayer);
        Tooltip.init(tooltipLayer);
    }

    QtObject {
        id: fakeGameSettingsModelInstance

        property bool hasDownloadPath: true
        property string installPath: "C:\\Program Files (x86)\\QGNA\\Games"
        property string downloadPath: "C:\\Program Files (x86)\\QGNA\\Downloads"

        function switchGame(serviceId) {
        }

        function createShortcutOnDesktop(serviceId) {
            console.log('[GameSettings] createShortcutOnDesktop', serviceId)
        }

        function createShortcutInMainMenu(serviceId) {
            console.log('[GameSettings] createShortcutInMainMenu', serviceId)
        }

        function isOverlayEnabled(serviceId) {
            return true;
        }

        function restoreClient()  {

        }
    }

    RequestServices {
        onReady: {
            var serviceItem = App.serviceItemByGameId("71");
            serviceItem.statusText = "Sample text";

            App.activateGame(serviceItem);
        }
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.GameSettings');
            manager.registerWidget('Application.Widgets.GameAdBanner');
            manager.registerWidget('Application.Widgets.GameLoad');
            manager.registerWidget('Application.Widgets.GameUninstall');
            manager.registerWidget('Application.Widgets.AlertAdapter');

            manager.init();

            //  stub
            App.executeService = function(serviceId) {
                console.log("App::executeService() called: " + serviceId);
            }

            App.gameSettingsModelInstance = function() {
                return fakeGameSettingsModelInstance;
            }
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            console.log("Closed popupId: " + popupId);
        }
    }

    Item {
        id: baseLayer

        anchors.fill: parent

        Image {
            anchors.centerIn: parent
            source: installPath + '/Tests/Assets/main_07.png'
        }

        Button {
            x: 10
            y: 98
            width: 160
            height: 36
            text: 'Настройки'
            onClicked: Popup.show('GameSettings');
        }
   }

    Item {
        id: popupLayer

        anchors.fill: parent
        z: 2
    }

    Item {
        id: messageboxLayer

        anchors.fill: parent
        z: 3
    }

    Item {
        id: tooltipLayer

        anchors.fill: parent
        z: 4
    }

//    Bootstrap {
//        anchors.fill: parent
//    }
}
