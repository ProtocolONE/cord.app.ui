/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
pragma Singleton

import QtQuick 2.4

import GameNet.Core 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Item {
    id: root

    property int premiumExpiredNotificationTimeout: 3600000
    property variant lastUpdated: 0

    signal nicknameChanged();
    signal balanceChanged();
    signal subscriptionsChanged();

    function refreshUserInfo() {
        RestApi.User.getProfile(d.userId, function(response) {
            if (!response || !response.userInfo || response.userInfo.length < 1) {
                return;
            }
            setUserInfo(response.userInfo[0].shortInfo);
            setUserSubscriptions(response.userInfo[0].subscriptions);
            d.level = response.userInfo[0].experience.level;
            root.lastUpdated = Date.now();
        }, function() {});

        refreshPremium();
        premiumDurationTimer.start();
        refreshBalance();
        balanceTimer.start();
    }

    function setUserSubscriptions(data) {
        var wasUpdated = false;

        data.filter(function(e){
            return e.dueDate !== null;
        }).map(function(e) {
            if (serviceSubscriptions.contains(e.serviceId)) {
                if (e.dueDate != serviceSubscriptions.getPropertyById(e.serviceId, "dueDate")) {
                    serviceSubscriptions.setPropertyById(e.serviceId, "dueDate", e.dueDate);
                    wasUpdated = true;
                }
            } else {
                serviceSubscriptions.append({
                    serviceId: e.serviceId,
                    gameId: e.gameId,
                    createDate: e.createDate,
                    dueDate: e.dueDate
                });
                wasUpdated = true;
            }
        });

        if (wasUpdated) {
            root.subscriptionsChanged();
        }
    }

    function refreshPremium() {
        premiumDurationTimer.stop();
        RestApi.Premium.getStatus(function(response) {
            var duration = response ? (response.duration | 0) : 0;
            if (duration > 0) {
                d.isPremium = true;
                d.premiumDuration = duration;
                premiumExpiredTimer.stop();
                premiumDurationTimer.start();
            } else {
                d.isPremium = false;
                d.premiumDuration = 0;
            }

        }, function(error) {
            d.isPremium = false;
            d.premiumDuration = 0;
        })
    }

    function refreshBalance() {
        RestApi.User.getBalance(function(response) {
            if (response.error) {
                return;
            }

            if (response && response.speedyInfo) {
                d.balance = response.speedyInfo.balance || "0";
            }

        }, function() {});
    }

    function setUserInfo(userInfo) {
        d.nickname = userInfo.nickname;
        d.nametech = userInfo.nametech;
        d.avatarLarge = userInfo.avatarLarge;
        d.avatarMedium = userInfo.avatarMedium;
        d.avatarSmall = userInfo.avatarSmall;
        d.guest = (userInfo.guest == 1);
        d.isLoginConfirmed = (userInfo.loginConfirmed || false);
    }

    function reset() {
        d.userId = "";
        d.appKey = "";
        d.cookie = "";
        d.isPremium = false;
        d.premiumDuration = 0;
        d.balance = 0;
        d.nickname = "";
        d.nametech = "";
        d.level = "";
        d.avatarLarge = "";
        d.avatarMedium = "";
        d.avatarSmall = "";
        serviceSubscriptions.clear();
    }

    function setCredential(userId, appKey, cookie) {
        d.userId = userId;
        d.appKey = appKey;
        d.cookie = cookie;
    }

    function userId() {
        return d.userId;
    }

    function appKey() {
        return d.appKey;
    }

    function cookie() {
        return d.cookie;
    }

    function isAuthorized() {
        return !!userId() && !!appKey() && !!cookie();
    }

    function isPremium() {
        return d.isPremium;
    }

    function isLoginConfirmed() {
        return d.isLoginConfirmed;
    }

    function getPremiumDuration() {
        return d.premiumDuration;
    }

    function getBalance() {
        return d.balance;
    }

    function setNickname(value) {
        d.nickname = value;
    }

    function getNickname() {
        return d.nickname;
    }

    function setTechname(value) {
        d.nametech = value;
    }

    function getTechName() {
        return d.nametech;
    }

    function getLevel() {
        return d.level;
    }

    function getAvatarLarge() {
        return d.avatarLarge;
    }

    function getAvatarMedium() {
        return d.avatarMedium;
    }

    function getAvatarSmall() {
        return d.avatarSmall;
    }

    function isGuest() {
        return d.guest;
    }

    function getUrlWithCookieAuth(url) {
        return d.cookie
                ? 'https://gnlogin.ru/?auth=' + d.cookie + '&rp=' + encodeURIComponent(url)
                : url;
    }

    function setSecondCredential(userId, appKey, cookie) {
        d.secondUserId = userId;
        d.secondAppKey = appKey;
        d.secondCookie = cookie;
    }

    function resetSecond() {
        setSecondCredential('', '', '');
        d.secondNickname = "";
    }

    function secondUserId() {
        return d.secondUserId;
    }

    function secondAppKey() {
        return d.secondAppKey;
    }

    function secondCookie() {
        return d.secondCookie;
    }

    function getSecondNickname() {
        return d.secondNickname;
    }

    function isSecondAuthorized() {
        return !!secondUserId() && !!secondAppKey() && !!secondCookie();
    }

    function isNicknameValid() {
        return getNickname().indexOf('@') == -1;
    }

    function getSubscriptions() {
        return serviceSubscriptions;
    }

    function getSubscriptionRemainTime(serviceId) {
        var subsrc = serviceSubscriptions.getById(serviceId),
            q = balanceTimer.tickCount && root.lastUpdated;

        return subsrc
            ? Moment.moment(subsrc.dueDate).diff(new Date(), 'days')
            : null;
    }

    function hasUnlimitedSubscription(serviceId) {
        return (getSubscriptionRemainTime(serviceId)|0) > 365 * 100;
    }

    QtObject {
        id: d

        property string userId
        property string appKey
        property string cookie

        property bool isPremium: false
        property bool isLoginConfirmed: false
        property int premiumDuration: 0
        property int balance: 0

        property string nickname
        property string nametech

        property string level
        property string avatarLarge
        property string avatarMedium
        property string avatarSmall

        property bool guest: false

        property string secondNickname
        property string secondUserId
        property string secondAppKey
        property string secondCookie
    }

    ExtendedListModel {
        id: serviceSubscriptions

        idProperty: "serviceId"
    }

    Connections {
        target: d

        onBalanceChanged: root.balanceChanged();
        onNicknameChanged: root.nicknameChanged();
    }

    Connections {
        target: SignalBus

        onLogoutRequest: {
            root.reset();
        }

        onProfileUpdated: refreshUserInfo();

        onAuthDone: {
            d.userId = userId;
            d.appKey = appKey;
            d.cookie = cookie;

            refreshUserInfo();
       }

       onSecondAuthDone: {
           d.secondUserId = userId;
           d.secondAppKey = appKey;
           d.secondCookie = cookie;

           RestApi.User.getProfile(d.secondUserId, function(response) {
               if (!response || !response.userInfo || response.userInfo.length < 1) {
                   return;
               }

               var info = response.userInfo[0].shortInfo;
               d.secondNickname = info.nickname;
           }, function() {});
       }
    }

    Timer {
        id: premiumDurationTimer

        interval: 60000

        triggeredOnStart: false
        repeat: true
        onTriggered: {
            var duration = d.premiumDuration - 60;
            if (duration <= 0) {
                if(d.premiumDuration > 0) {
                    premiumExpiredTimer.start();
                }
                d.premiumDuration = 0;
                d.isPremium = false;
                root.refreshPremium();
            } else {
                d.premiumDuration = duration;
            }
        }
    }

    Timer {
        id: premiumExpiredTimer

        interval: premiumExpiredNotificationTimeout
        onTriggered: SignalBus.premiumExpired();
    }

    Timer {
        id: balanceTimer

        property int tickCount: 0

        interval: 60000
        triggeredOnStart: true
        repeat: true

        onTriggered: {
            var localTick = balanceTimer.tickCount + 1;
            if ((App.isWindowVisible() && localTick >= 2) || localTick >= 5) {
                balanceTimer.tickCount = 0;
                refreshBalance();
            } else {
                balanceTimer.tickCount++;
            }
        }
    }
}
