pragma Singleton

import QtQuick 1.1

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Config 1.0

Item {
    id: root

    signal subscriptionsChanged();

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

            var info = response.userInfo[0].shortInfo;
            setUserInfo(info);
            setUserSubscriptions(response.userInfo[0].subscriptions);
            root.level = response.userInfo[0].experience.level;

            //mainAuthModule.updateGuestStatus(info.guest || "0");
        }, function() {});

        refreshPremium();
        premiumDurationTimer.start();
        refreshBalance();
        balanceTimer.start();
    }

    function setUserSubscriptions(data) {
        var wasUpdated = false;
        data.filter(function(e) {
            var service = App.serviceItemByServiceId(e.serviceId)
            return e.dueDate !== null || (service && service.isStandalone);
        }).map(function(e) {
                    // HACK
//                    if (e.serviceId == "30000000000") {
//                        e.dueDate = Moment.moment().add(7, 'days');
//                    }


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
            response = response || {};

            var duration = response.duration;
            if (typeof duration === "undefined" || typeof duration === "boolean" ||duration === null) {
                duration = 0;
            } else {
                duration = +duration;
            }

            if (duration > 3001 * 24*60*60) {
                duration = 3001 * 24*60*60
            }

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
                d.isPromoActionActive = response.speedyInfo.mustGetDoubleCoins == 1;
            }

        }, function() {});
    }

    function setUserInfo(userInfo) {
        d.nickname = userInfo.nickname;
        d.nametech = userInfo.nametech;
        d.avatarLarge = userInfo.avatarLarge;
        d.avatarMedium = userInfo.avatarMedium;
        d.avatarSmall = userInfo.avatarSmall;
        d.isLoginConfirmed = (userInfo.loginConfirmed || false);
    }

    function reset() {
        root.userId = "";
        root.appKey = "";
        root.cookie = "";
        root.isPremium = false;
        root.premiumDuration = 0;
        root.balance = 0;
        root.nickname = "";
        root.nametech = "";
        root.level = "";
        root.avatarLarge = "";
        root.avatarMedium = "";
        root.avatarSmall = "";
        serviceSubscriptions.clear();
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

    function isPromoActionActive() {
        return d.isPromoActionActive;
    }

    // INFO Этот метод лучше не использовать.
    // По возможности надо использоваьт метод App.openExternalUrlWithAuth.
    // В том методе не используется кука, что безопаснее.
    function getUrlWithCookieAuth(url) {
        return  d.cookie
                ? Config.login("/?auth=") + d.cookie + '&rp=' + encodeURIComponent(url)
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
            ? Moment.moment(subsrc.dueDate).startOf('day').diff(Moment.moment().startOf('day'), 'days')
            : null;
    }

    function hasUnlimitedSubscription(serviceId) {
        return (getSubscriptionRemainTime(serviceId)|0) > 365 * 30;
    }

    function hasBoughtStandaloneGame(serviceId) {
        var result = serviceSubscriptions.contains(serviceId),
            q = balanceTimer.tickCount && root.lastUpdated;

        return result;
    }

    function hadSubscriptionsByService(serviceId) {
        var subscription = serviceSubscriptions.getById(serviceId);
        var hadSubscruption = !!subscription && !!subscription.dueDate;
        return hadSubscruption;
    }

    function isAnotherComputer() {
        return d.anotherComputer;
    }

    function balanceChangedByPush(newBalance) {
        d.balance = newBalance;
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

        property string secondNickname
        property string secondUserId
        property string secondAppKey
        property string secondCookie

        property bool isPromoActionActive: false

        property bool anotherComputer: false
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

        onAnotherComputerChanged: {
            d.anotherComputer = value;
        }

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
