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

import "../../../Application/Core/App.js" as AppJs

Item {
    width: 1000
    height: 599

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.SilentMode');
            manager.init();

            AppJs.activateGame(AppJs.serviceItemByGameId("92"));

            //  перекрываем функции для тестовых нужд
            AppJs.isWindowVisible = function() {
                return false;
            }
            AppJs.isSilentMode = function() {
                return true;
            }
            AppJs.isServiceInstalled = function(serviceId) {
                return false;
            }
            AppJs.hideMainWindow = function() {
                console.log("Hide mainWindow.");
            }
            AppJs.activateWindow = function() {
                console.log("Activate mainWindow.");
            }
        }
    }

    Button {
        x: 300
        y: 300
        width: 200
        height: 30

        text: "AppJs.serviceInstalled: 92"
        onClicked: AppJs.serviceInstalled(AppJs.serviceItemByGameId("92"));
    }

    Button {
        x: 300
        y: 350
        width: 200
        height: 30

        text: "AppJs.downloaderStarted: 92"
        onClicked: AppJs.downloaderStarted(AppJs.serviceItemByGameId("92"));
    }
}
