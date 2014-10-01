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

import "../../Core/App.js" as App
import "../../Core/Popup.js" as Popup
import "../../Core/restapi.js" as RestApi
import "../../Core/TrayPopup.js" as TrayPopup
import "../../Core/MessageBox.js" as MessageBox
import "../../Core/User.js" as User
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics

WidgetModel {
    id: root

    property int internalPopupId: -1
    property variant enterNickNameViewModelInstance: App.enterNickNameViewModelInstance()

    function startExecuting(serviceId) {
        var gameItem;

        executeServiceDelay.serviceId = serviceId;
        executeServiceDelay.start();

        gameItem = App.serviceItemByServiceId(serviceId);
        gameItem.status = "Starting";
        gameItem.statusText = qsTr("TEXT_PROGRESSBAR_STARTING_STATE")
        App.updateProgress(gameItem);
    }

    Connections {
        target: enterNickNameViewModelInstance || null
        ignoreUnknownSignals: true
        onStartCheck: {
            if (User.isNicknameValid()) {
                enterNickNameViewModelInstance.success();
            } else {
                root.internalPopupId = Popup.show('NicknameEdit');
            }
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            if (root.internalPopupId !== popupId) {
                return;
            }

            if (User.isNicknameValid()) {
                enterNickNameViewModelInstance.success();
            } else {
                enterNickNameViewModelInstance.failed();
            }
        }
    }

    Connections {
        target: App.signalBus()

        onSelectService: {
            //TODO Вероятно эта логика должна быть вынесена в какое-то другое место. Более "высокое".
            App.activateGameByServiceId(serviceId);
            App.navigate("mygame");
        }

        onNeedPakkanenVerification: {
            Popup.show('AccountActivation');
        }
    }

    Connections {
        target: App.mainWindowInstance()

        onServiceFinished: {  // ввод промо кода
            //--------------------------------------------------------------
            //INFO Парни, этот код нужен ровно на 3 суток. Простите, за 100500 но очень не хочется добавлять сигнал
            //отдельный чтобы его тут же удалить. https://jira.gamenet.ru:8443/browse/QGNA-1037

            if (service == "30000000000" && serviceState == 100500) {
                App.activateGameByServiceId(service);
                App.navigate('mygame', 'GameItem');

                MessageBox.show(
                            qsTr("Вам нужен ключ доступа"),
                            qsTr("Скачать клиент игры могут только участники F&F-теста. Если у вас есть ключ доступа, нажмите \"Да\"."),
                            MessageBox.button.Yes | MessageBox.button.No,
                            function(result) {
                                console.log(result)
                                if (result == 16384) {
                                    //INFO Думаете магия? Кто-то проебался и колбек деоргается восем не с
                                    //теми аргументами, как обещано в справке - обещали f(id, button), но по факту не
                                    //то. Исправят тут https://jira.gamenet.ru:8443/browse/QGNA-1044
                                    Popup.show('PromoCode');
                                }
                            });
                return;
            }
            //--------------------------------------------------------------

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
            var total = App.executeGameTotalCount(serviceId);
            return total <= 2;
        }

        function isAlreadyHandledErrorState(serviceState) {
            return [5, 6, 102, 125, 601, 603].indexOf(serviceState) != -1;
        }

        target: App.mainWindowInstance()
        ignoreUnknownSignals: true

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

    Timer {
        id: executeServiceDelay

        property string serviceId

        interval: 5000

        onTriggered: {
            var gameItem;

            if (!executeServiceDelay.serviceId) {
                return;
            }

            gameItem = App.serviceItemByServiceId(executeServiceDelay.serviceId);
            gameItem.statusText = '';

            if (!App.executeService(executeServiceDelay.serviceId)) {
                gameItem.status = "Normal";
            } else {
                gameItem.status = "Started";
            }

            App.updateProgress(gameItem);
        }
    }
}
