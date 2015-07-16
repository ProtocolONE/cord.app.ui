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
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import Application.Core 1.0
import Application.Core.MessageBox 1.0

WidgetModel {
    id: root

    property alias premiumModel: optionsModel
    property int defaultIndex: -1
    property bool inProgress: false

    signal modelChanged();
    signal purchaseCompleted();

    function buy(optionId, days) {
        root.inProgress = true;
        RestApi.Premium.purchase(optionId,
                                 function(response) {
                                     d.purchaseComplete(response, days);
                                 },
                                 function(response) {
                                     root.inProgress = false;
                                     d.showError();
                                 });
    }

    function refreshModel() {
        var i;

        RestApi.Premium.getGrid(function(response) {
            root.premiumModel.clear();

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
        }, function(response) {
            root.modelChanged();
        });
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

        function purchaseComplete(response, days) {
            root.inProgress = false;
            if (response && response.error) {
                d.showError(response.error.message);
                return;
            }

            root.purchaseCompleted();
            User.refreshBalance();
            User.refreshPremium();

            MessageBox.show(qsTr("PREMIUM_BUY_SUCCESS_CAPTION").arg(days),
                            qsTr("PREMIUM_SHOP_BUY_SUCCESS_DETAILS"),
                            MessageBox.button.ok);
        }

        function showError(message) {
            MessageBox.show(qsTr("PREMIUM_BUY_ERROR_CAPTION"),
                            message || qsTr("PREMIUM_SHOP_DETAILS_ERROR_UNKNOWN"),
                            MessageBox.button.ok, function(result) {
                                root.inProgress = false;
                            });
        }

    }

    ListModel {
        id: optionsModel
    }
}
