import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import Application.Blocks 1.0

import Application.Core 1.0
import Application.Core.Popup 1.0
import Application.Core.MessageBox 1.0
import "../../../ProtocolOne/Components/Widgets/WidgetManager.js" as WidgetManager

WidgetModel {
    id: root

    signal closeView();

    property int internalPopupId: -1
    property int internalP2PTransferPopupId: -1

    function startExecuting(serviceId) {
        var gameItem = App.serviceItemByServiceId(serviceId);
        executeServiceDelay.serviceId = serviceId;

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
        root.internalP2PTransferPopupId = -1;
        executeServiceDelay.start();

        gameItem.status = "Starting";
        gameItem.statusText = qsTr("TEXT_PROGRESSBAR_STARTING_STATE")
        SignalBus.progressChanged(gameItem);
    }

//    Connections {
//        id: p2pTransferRequestConnection

//        ignoreUnknownSignals: true
//        onProceed: {
//            // INFO fast execute after P2PTransferPopup
//            executeServiceDelay.interval = 500;
//            root.executeGame(executeServiceDelay.serviceId);
//        }

//        onCheckLicensedResult: {
//            if (!shouldShow) {
//                root.executeGame(executeServiceDelay.serviceId);
//                return;
//            }

//            root.internalP2PTransferPopupId = Popup.show('P2PTransferRequest');
//            root.closeView();
//        }
//    }

    Connections {
        target: Popup
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

            executeServiceDelay.interval = 5000;

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
