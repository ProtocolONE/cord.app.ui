import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0

WidgetModel {
    id: root

    property alias premiumModel: optionsModel
    property int defaultIndex: -1
    property bool inProgress: false
    property string supportedGames: (function(){
        return App.getServicesWithExtendedAccountedSupport()
            .map(function(e) {
                return e.name;
            }).join(', ');
    })();


    signal modelChanged();
    signal purchaseCompleted();

    function buy(optionId) {
        root.inProgress = true;
        RestApi.Billing.purchaseItem(0, optionId, 1, root.purchaseComplete, root.showError);
    }

    function purchaseComplete(response) {
        root.inProgress = false;
        if (response && response.error) {
            root.showError(response.error.message);
            return;
        }

        root.purchaseCompleted();
        User.refreshBalance();
        User.refreshPremium();

        MessageBox.show(qsTr("Расширенный аккаунт активирован"),
                        qsTr("Чтобы запустить второе окно игры %1 нажмите «Добавить аккаунт» и авторизуйтесь вторым аккаунтом. Запуск игры под вторым аккаунтом происходит по кнопке «Начать игру» в блоке дополнительного аккаунта и доступен после запуска игры под основным аккаунтом. </br>Приятной игры.").arg(root.supportedGames),
                        MessageBox.button.ok);
    }

    function showError(message) {
        root.inProgress = false;
        MessageBox.show(qsTr("PREMIUM_BUY_ERROR_CAPTION"),
                        message || qsTr("PREMIUM_SHOP_DETAILS_ERROR_UNKNOWN"),
                        MessageBox.button.ok, function(result) {
                            root.inProgress = false;
                        });
    }

    function refreshModel() {
        RestApi.Service.getItems("0", 13, function(response) {
            response.sort(function(a, b) {
                return a.cost - b.cost;
            });

            root.premiumModel.clear();
            optionsModel.clear();

            response.forEach(function(e) {
                optionsModel.append({id: String(e.id), name: e.name, cost: e.cost|0});
            });

            root.defaultIndex = response.length - 1;
            root.modelChanged();
        }, function(response) {
            root.modelChanged();
        });
    }

    ListModel {
        id: optionsModel
    }
}
