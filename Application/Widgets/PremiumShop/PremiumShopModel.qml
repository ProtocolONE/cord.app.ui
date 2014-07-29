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
import GameNet.Components.Widgets 1.0
import "../../Core/restapi.js" as RestApi
import "../../Core/User.js" as User
import "../../Core/MessageBox.js" as MessageBox

WidgetModel {
    id: root

    property alias premiumModel: optionsModel
    property int defaultIndex: -1
    property bool inProgress: false

    signal modelChanged();
    signal purchaseCompleted();

    function buy(optionId) {
        root.inProgress = true;
        RestApi.Premium.purchase(optionId,
                                 d.purchaseComplete,
                                 function(response) {
                                     root.inProgress = false;
                                     d.showError();
                                 });
    }

    function refreshModel() {
        var i;

        RestApi.Premium.getGrid(function(response) {
            optionsModel.clear();

            var max = response && response[0] ? response[0].price : 0,
                index = 0;

            for (i = 0; i < response.length; i++) {
                d.addOption(response[i].gridId, response[i].days, response[i].price);
                if (response[i].price > max) {
                    index = i;
                    max = response[i].price;
                }
            }

            root.defaultIndex = index;
            root.modelChanged();
        }, function(response) {});
    }

    QtObject {
        id: d

        function addOption(optId, daysCount, optionPrice) {
            optionsModel.append(
                        {
                            optionId: optId,
                            label: d.makeDays(daysCount),
                            price: optionPrice,
                            days: daysCount
                        });
        }

        function makeDays(daysCount) {
            var resultStr;
            var map = {
                0: qsTr('PREMIUM_SHOP_DAYS_OTHER'),
                1: qsTr('PREMIUM_SHOP_DAYS_1'),
                2: qsTr('PREMIUM_SHOP_DAYS_2_4'),
                3: qsTr('PREMIUM_SHOP_DAYS_2_4'),
                4: qsTr('PREMIUM_SHOP_DAYS_2_4'),
            };

            resultStr = map[daysCount] || map[0];
            return resultStr.arg(daysCount);
        }

        function purchaseComplete(response) {
            root.inProgress = false;
            if (response && response.error) {
                d.showError(response.error.message);
                return;
            }

            root.purchaseCompleted();
            User.refreshBalance();
            User.refreshPremium();
        }

        function showError(message) {
            MessageBox.show("PREMIUM_BUY_ERROR_CATION",
                            message || qsTr("PREMIUM_SHOP_DETAILS_ERROR_UNKNOWN"),
                            MessageBox.button.Ok, function(result) {
                                root.inProgress = false;
                            });
        }

    }

    ListModel {
        id: optionsModel
    }

    Component.onCompleted: {
        root.refreshModel();
    }
}
