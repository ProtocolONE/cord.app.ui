/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Dev 1.0
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Item {
    width: 1000
    height: 599

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.SilentMode');
            manager.init();

            // UNDONE тут работает ли переопределение функций в qml... есть шанс что нет
            App.activateGame(App.serviceItemByGameId("92"));

            // UNDONE Не работает пока переопределение
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
        onClicked: SignalBus.serviceInstalled(AppJs.serviceItemByGameId("92"));
    }

    Button {
        x: 300
        y: 350
        width: 200
        height: 30

        text: "AppJs.downloaderStarted: 92"
        onClicked: SignalBus.downloaderStarted(AppJs.serviceItemByGameId("92"));
    }
}
