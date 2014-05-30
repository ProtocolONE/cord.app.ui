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
import "App.js" as AppJs
import "restapi.js" as RestApiJs

WidgetModel {
    id: root

    property string userId
    property string appKey
    property string cookie

    property bool isPremium: false
    property int premiumDuration: 0
    property int balance: 0

    property string nickname
    property string nametech

    property string level
    property string avatarLarge
    property string avatarMedium
    property string avatarSmall

    property bool guest: false

    function refreshUserInfo() {
        RestApiJs.User.getProfile(root.userId, function(response) {
            if (!response || !response.userInfo || response.userInfo.length < 1) {
                return;
            }

            var info = response.userInfo[0].shortInfo;
            setUserInfo(info);
            root.level = response.userInfo[0].experience.level;
            //mainAuthModule.updateGuestStatus(info.guest || "0");
        }, function() {});

        refreshPremium();
        premiumDurationTimer.start();
        refreshBalance();
        balanceTimer.start();
    }

    function refreshPremium() {
        premiumDurationTimer.stop();
        RestApiJs.Premium.getStatus(function(response) {
            var duration = response ? (response.duration | 0) : 0;
            if (duration > 0) {
                root.isPremium = true;
                root.premiumDuration = duration;
                premiumExpiredTimer.stop();
                premiumDurationTimer.start();
            } else {
                root.isPremium = false;
                root.premiumDuration = 0;
            }

        }, function(error) {
            root.isPremium = false;
            root.premiumDuration = 0;
        })
    }

    function refreshBalance() {
        RestApiJs.User.getBalance(function(response) {
            if (response.error) {
                return;
            }

            if (response && response.speedyInfo) {
                root.balance = response.speedyInfo.balance || "0";
            }

        }, function() {});
    }

    function setUserInfo(userInfo) {
        root.nickname = userInfo.nickname;
        root.nametech = userInfo.nametech;
        root.avatarLarge = userInfo.avatarLarge;
        root.avatarMedium = userInfo.avatarMedium;
        root.avatarSmall = userInfo.avatarSmall;
        root.guest = (userInfo.guest == 1);
    }

    Connections {
        target: AppJs.signalBus();
        onAuthDone: {
            root.userId = userId;
            root.appKey = appKey;
            root.cookie = cookie;

            RestApiJs.Core.setUserId(userId);
            RestApiJs.Core.setAppKey(appKey);
            //  UNDONE: надо решить как скармиливать параметры в рест апи,
            //  чтоб в этом месте они уже гарантированно там были
            refreshUserInfo();
       }
    }

    Timer {
        id: premiumDurationTimer

        interval: 60000
        triggeredOnStart: false
        repeat: true
        onTriggered: {
            var duration = root.premiumDuration - 60;
            if (duration <= 0) {
                if(root.premiumDuration > 0) {
                    premiumExpiredTimer.start();
                }
                root.premiumDuration = 0;
                root.isPremium = false;
                root.refreshPremium();
            } else {
                root.premiumDuration = duration;
            }
        }
    }

    Timer {
        id: premiumExpiredTimer

        interval: 3600000
        onTriggered: {
            AppJs.signalBus().premiumExpired();
        }
    }

    Timer {
        id: balanceTimer

        property int tickCount: 0

        interval: 60000
        triggeredOnStart: true
        repeat: true

        onTriggered: {
            balanceTimer.tickCount++;
            if ((AppJs.isWindowVisible() && balanceTimer.tickCount >= 2) || balanceTimer.tickCount >= 5) {
                balanceTimer.tickCount = 0;
                refreshBalance();
            }
        }
    }

}
