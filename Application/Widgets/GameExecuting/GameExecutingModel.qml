/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import Tulip 1.0
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import Application.Blocks 1.0

import "../../Core/App.js" as App
import "../../Core/Popup.js" as Popup
import "../../Core/restapi.js" as RestApi
import "../../Core/TrayPopup.js" as TrayPopup
import "../../Core/MessageBox.js" as MessageBox
import "../../Core/User.js" as User
import "../../../GameNet/Core/GoogleAnalytics.js" as GoogleAnalytics
import "../../../GameNet/Components/Widgets/WidgetManager.js" as WidgetManager

WidgetModel {
    id: root

    signal closeView();

    property int internalPopupId: -1
    property int internalP2PCancelRequestPopupId: -1

    function startExecuting(serviceId) {
        var gameItem = App.serviceItemByServiceId(serviceId);
        executeServiceDelay.serviceId = serviceId;

        if (serviceId === "30000000000") {
            var subsriptionRemainTime = User.getSubscriptionRemainTime(serviceId);
            if (subsriptionRemainTime > 0) {
                p2pCancelRequestConnection.target = WidgetManager.getWidgetByName('P2PCancelRequest').model;
                root.internalP2PCancelRequestPopupId = Popup.show('P2PCancelRequest');
                root.closeView();
                return;
            }
        }

        if (gameItem.checkNicknameBeforeStart && !User.isNicknameValid()) {
            root.internalPopupId = Popup.show('NicknameEdit');
            root.closeView();
            return;
        }

        root.executeGame(serviceId);
        return;
    }

    function executeGame(serviceId) {
        var gameItem = App.serviceItemByServiceId(serviceId);
        root.internalPopupId = -1;
        root.internalP2PCancelRequestPopupId = -1;
        executeServiceDelay.start();

        gameItem.status = "Starting";
        gameItem.statusText = qsTr("TEXT_PROGRESSBAR_STARTING_STATE")
        SignalBus.progressChanged(gameItem);
    }

    Connections {
        id: p2pCancelRequestConnection

        ignoreUnknownSignals: true
        onLicenseAccepted: {
            RestApi.Core.execute('user.acceptLicense', { serviceId : executeServiceDelay.serviceId, licenseId: "1" },
                                 true, function(response) {
                                     User.refreshUserInfo();
                                 });

            root.executeGame(executeServiceDelay.serviceId);
        }

        onLicenseSkipped: {
            root.executeGame(executeServiceDelay.serviceId);
        }
    }

    Connections {
        target: Popup.signalBus()
        onClose: {
            if (root.internalPopupId !== popupId) {
                return;
            }

            if (User.isNicknameValid()) {
                root.executeGame(executeServiceDelay.serviceId);
                return;
            }

            var gameItem = App.serviceItemByServiceId(executeServiceDelay.serviceId);
            gameItem.status = "Normal";
            gameItem.statusText = '';
            SignalBus.progressChanged(gameItem);
        }
    }

    Connections {
        target: SignalBus

        onSelectService: {
            //TODO Вероятно эта логика должна быть вынесена в какое-то другое место. Более "высокое".
            App.activateGameByServiceId(serviceId);
            SignalBus.navigate("mygame", "");
        }

        onNeedPakkanenVerification: Popup.show('AccountActivation');
    }

    Connections {
        target: App.mainWindowInstance()

        onServiceFinished: {  // ввод промо кода
            //--------------------------------------------------------------
            //INFO Парни, этот код нужен ровно на 3 суток. Простите, за 100500 но очень не хочется добавлять сигнал
            //отдельный чтобы его тут же удалить. https://jira.gamenet.ru:8443/browse/QGNA-1037

            if (service == "30000000000" && serviceState == 100500) {
                App.activateGameByServiceId(service);
                SignalBus.navigate('mygame', 'GameItem');

                MessageBox.show(
                            qsTr("Вам нужен ключ доступа"),
                            qsTr("Скачать клиент игры могут только участники F&F-теста. Если у вас есть ключ доступа, нажмите \"Да\"."),
                            MessageBox.button.yes | MessageBox.button.no,
                            function(result) {
                                if (result == MessageBox.button.yes) {
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
            var total = ApplicationStatistic.executeGameTotalCount(serviceId);
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

            if (!User.isAuthorized()) {
                return;
            }

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

            SignalBus.progressChanged(gameItem);
        }
    }
}
