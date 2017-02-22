/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2017, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

import QtQuick 2.4
import QtQuick.Window 2.2

import Tulip 1.0

import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Dev 1.0

import Application.Core 1.0
import Application.Core.Settings 1.0
import Application.Core.Popup 1.0
import Application.Core.Styles 1.0

Window {
    id: root

    width: 1000
    height: 600
    color: '#AAAAAA'

    function initRestApi(options) {
        RestApi.http.logRequest = true;
        RestApi.Core.setup({
                               lang: 'ru',
                               genericErrorCallback: function(code, message) {
                                   if (code == RestApi.Error.AUTHORIZATION_FAILED
                                       || code == RestApi.Error.ACCOUNT_NOT_EXISTS
                                       || code == RestApi.Error.AUTHORIZATION_LIMIT_EXCEED
                                       || code == RestApi.Error.UNKNOWN_ACCOUNT_STATUS) {
                                       console.log('RestApi generic error', code, message);
                                   }

                               }
                           });
    }

    function authDone(userId, appKey) {
        initRestApi();
        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        SignalBus.authDone(userId, appKey, "");
    }

    function requestServices() {
        RestApi.Service.getUi(function(result) {
            App.fillGamesModel(result);
            SignalBus.setGlobalState("Authorization");

            root.ready();
        }, function(result) {
            console.log('get services error', result);
            retryTimer.start();
        });
    }

    function ready() {
        App.activateGame(App.serviceItemByServiceId("30000000000"));
    }

    Component.onCompleted: {
        Popup.init(popupLayer);
        Moment.moment.lang('ru');

        WidgetManager.registerWidget('Application.Widgets.P2PTransferRequest')

        WidgetManager.registerWidget('Application.Widgets.GameAdBanner');
        WidgetManager.registerWidget('Application.Widgets.GameInfo');
        WidgetManager.registerWidget('Application.Widgets.GameExecuting');

        WidgetManager.init()

        User.reset();
        authDone("400001000001634860", "4c2f65777d38eb07d32d111061005dcd5a119150");

        root.requestServices()
        //authDone("400001000005869460", "fac8da16caa762f91607410d2bf428fb7e4b2c5e");

//        SignalBus.authDone("400001000005869460",
//                           "fac8da16caa762f91607410d2bf428fb7e4b2c5e",
//                           "C%2FnfbUvBF5mziviOv4Qntt275i7PJlQl0MnKFISd6zjEfqvubcQjTC5TNssFUDDNbA0M5JfVlealM0g11k7xAliCVZyJtzUXdm1GnVHoCDTWRwRMC4iJ4riOrP2wgewASRhihO8jcypODjRreKybo5%2F42muKAphYtNd8azJfUWs0RHUPOtchKWXVqHVUqEo4f0R9yGah7p%2FWp79G%2Br%2BGIiq%2BxvV52cMpPyOtjMwprAmMEQPXu%2FoLapciJnV59mLpmWOmJJMB8Hyowk4Xlqw8Nmy3V7ztSPoHdluKkQw%2BxMm8PnKeAX%2Fg%2BFyDa1x35%2BPyTaQrpq3A3mMZdcrA8lELqql8Em7MZuxUeT0dZzeeFqf7yrPZqGq%2FzpyjFmuP6IcYCNTLM6ztP%2FKxLvY");


    }

    Button {
        x: 50
        y: 50
        width: 100
        height: 30
        text: "Open"

        onClicked: {

            AppSettings.setAppSettingsValue(
                                "P2PTransferRequest",
                                "30000000000",
                                0);

            Popup.show('GameExecuting', '', 1);
        }
    }

    Connections {
        id: p2pTransferRequestConnection

        ignoreUnknownSignals: true
        onProceed: {
            console.log('execute ', serviceId)
        }
    }


    Item {
        id: popupLayer

        anchors.fill: parent
    }

}
