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
import "./restapi.js" as RestApi
import "./Core.js" as Core

Item {
    id: root

    property string userId
    property string appKey
    property string cookie

    property string balance: "0"

    property string nickname
    property string nametech
    property string avatarLarge
    property string avatarMedium
    property string avatarSmall
    property string level
    property bool guest: false

    property bool isPremium: false
    property int premiumDuration: 0

    signal logoutDone();
    signal authDone();

    function refreshPremium() {
        premiumDurationTimer.stop();
        RestApi.Premium.getStatus(function(response) {
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
        RestApi.User.getBalance(function(response) {
            if (response.error) {
                return;
            }

            if (response && response.speedyInfo) {
                root.balance = response.speedyInfo.balance || "0";
            }

        }, function() {});
    }

    function logout() {
        root.userId = "";
        root.appKey = "";
        root.cookie = "";
        root.logoutDone();
    }

    function auth(userId, appKey, cookie) {
        root.userId = userId;
        root.appKey = appKey;
        root.cookie = cookie;
        root.authDone();
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
            Core.premiumExpired();
        }
    }
}
