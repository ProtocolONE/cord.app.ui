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
import Tulip 1.0
import GameNet.Components.Widgets 1.0
import Application.Blocks 1.0

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/Popup.js" as Popup
import "../../../Application/Core/restapi.js" as RestApi
import "../../../Application/Core/TrayPopup.js" as TrayPopup
import "../../../Application/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetModel {
    id: root

    Connections {
        target: enterNickNameViewModel
        onStartCheck: Popup.show('NicknameEdit');
    }

    Connections {
        target: App.signalBus()

        onSelectService: {
            App.activateGameByServiceId(serviceId);
            App.navigate("mygame");
        }

        onNeedPakkanenVerification: {
            Popup.show('AccountActivation');
        }

        onServiceFinished: {  // ввод промо кода
            if (serviceState !== RestApi.Error.SERVICE_AUTHORIZATION_IMPOSSIBLE) {
                return;
            }

            Popup.show('PromoCode');
        }
    }

    Connections { // коты
        id: gameExecuteTime

        property variant startTime

        function showCats(serviceId) {
            var succes = +(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "successCount", "0")),
                fail = +(Settings.value("gameExecutor/serviceInfo/" + serviceId + "/", "failedCount", "0"));
            return (succes + fail) <= 2;
        }

        function isAlreadyHandledErrorState(serviceState) {
            return [5, 6, 102, 125, 601, 603].indexOf(serviceState) != -1;
        }

        target: mainWindow

        onServiceStarted: {
            var item = App.serviceItemByServiceId(service);
            if (!item || item.gameType == "browser") {
                return;
            }

            gameExecuteTime.startTime = +(new Date()) / 1000;
        }

        onServiceFinished: {
            if (gameExecuteTime.isAlreadyHandledErrorState(serviceState)) {
                return;
            }

            var item = App.serviceItemByServiceId(service);
            if (!gameExecuteTime.startTime || !item || item.gameType == "browser") {
                return;
            }

            var finishTime = +(new Date()) / 1000;
            var time = finishTime - gameExecuteTime.startTime;
            gameExecuteTime.startTime = undefined;

            if (time < 20) {
                Popup.show('GameFailed');
            } else if (time < 300) {
                if (!gameExecuteTime.showCats(service)) {
                    return;
                }

                App.activateGameByServiceId(service);
                Popup.show('GameIsBoring');
            }
        }
    }
}
