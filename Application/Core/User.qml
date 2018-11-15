pragma Singleton

import QtQuick 2.4

import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import Application.Core.Config 1.0
import Application.Core.Authorization 1.0
import Application.Core.Settings 1.0
import Application.Core.ServerTime 1.0

import Tulip 1.0

Item {
    id: root

    property int premiumExpiredNotificationTimeout: 3600000
    property variant lastUpdated: 0

    signal nicknameChanged();
    signal balanceChanged();
    signal subscriptionsChanged();

    function refreshUserInfo() {
//        RestApi.User.getProfile(d.userId, function(response) {
//            if (!response || !response.userInfo || response.userInfo.length < 1) {
//                return;
//            }
//            setUserInfo(response.userInfo[0].shortInfo);
//            //setUserSubscriptions(response.userInfo[0].subscriptions);
//            d.level = response.userInfo[0].experience.level;
//            root.lastUpdated = Date.now();
//        }, function() {});

        //refreshPremium();
        //premiumDurationTimer.start();
        //refreshBalance();
        //balanceTimer.start();
    }

//    function setUserSubscriptions(data) {
//        var wasUpdated = false;
//        data.filter(function(e) {
//            var service = App.serviceItemByServiceId(e.serviceId)
//            return e.dueDate !== null || (service && service.isStandalone);
//        }).map(function(e) {
//            if (serviceSubscriptions.contains(e.serviceId)) {
//                if (e.dueDate != serviceSubscriptions.getPropertyById(e.serviceId, "dueDate")) {
//                    serviceSubscriptions.setPropertyById(e.serviceId, "dueDate", e.dueDate);
//                    wasUpdated = true;
//                }
//            } else {
//                serviceSubscriptions.append({
//                    serviceId: e.serviceId,
//                    gameId: e.gameId,
//                    createDate: e.createDate,
//                    dueDate: e.dueDate
//                });
//                wasUpdated = true;
//            }
//        });

//        if (wasUpdated) {
//            root.subscriptionsChanged();
//        }
//    }

//    function refreshPremium() {
//        premiumDurationTimer.stop();
//        RestApi.Premium.getStatus(function(response) {
//            response = response || {};

//            var duration = response.duration;
//            if (typeof duration === "undefined" || typeof duration === "boolean" ||duration === null) {
//                duration = 0;
//            } else {
//                duration = +duration;
//            }

//            if (duration > 3001 * 24*60*60) {
//                duration = 3001 * 24*60*60
//            }

//            if (duration > 0) {
//                d.isPremium = true;
//                d.premiumDuration = duration;
//                premiumExpiredTimer.stop();
//                premiumDurationTimer.start();
//            } else {
//                d.isPremium = false;
//                d.premiumDuration = 0;
//            }

//        }, function(error) {
//            d.isPremium = false;
//            d.premiumDuration = 0;
//        })
//    }

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
        d.refreshToken = '';
        d.acccessToken = '';
        d.refreshTokenExpiredTime = '';
        d.acccessTokenExpiredTime = '';
        d.rememberToken = false;

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

    function setTokenRemember(value) {
        d.rememberToken = value;
    }

    function setTokens(refreshToken, refreshTokenExpireTime,
                       accessToken, accessTokenExpireTime)
    {
        var oldJwt = {
            value: d.accessToken,
            exp: d.acccessTokenExpiredTime
        }

        d.refreshToken = refreshToken || '';
        d.refreshTokenExpiredTime = refreshTokenExpireTime || '';
        d.acccessToken = accessToken || '';
        d.acccessTokenExpiredTime = accessTokenExpireTime || '';

        var jwt = Authorization.decodeJwt(accessToken) || {};
        if (jwt.hasOwnProperty('payload') && jwt.payload.hasOwnProperty('id'))
            d.userId = jwt.payload.id;


        console.log('UserId: ', d.userId);
        if (d.rememberToken && !!d.refreshToken) {
            root.saveCreadential();
        }

        App.updateAuthCredential(
            oldJwt.value,
            oldJwt.exp,
            d.acccessToken,
            d.acccessTokenExpiredTime);

        SignalBus.authTokenChanged();
    }

    function refreshTokens() {
        Authorization.refreshToken(d.refreshToken, function(code, response) {
            if (code != Authorization.Result.Success) {
                root.reset();
                SignalBus.logoutRequest();
                return;
            }

            root.setTokens(response.refreshToken.value,
                           ServerTime.correctTime(response.refreshToken.exp),
                           response.accessToken.value,
                           ServerTime.correctTime(response.accessToken.exp));
        })
    }

    function getAccessToken() {
        return {
            value: d.acccessToken,
            exp: d.acccessTokenExpiredTime
        };
    }

    function isAccessTokenValid() {
        return !!d.acccessToken &&
                (Moment.moment(d.acccessTokenExpiredTime, 'X') > Moment.moment())
    }

    function saveCreadential() {
        AppSettings.setValue("qml/auth/", "refreshToken", d.refreshToken);
        AppSettings.setValue("qml/auth/", "refreshTokenExpiredTime", d.refreshTokenExpiredTime);
    }

    function loadCredential() {
        return {
            refreshToken: AppSettings.value("qml/auth/", "refreshToken", ""),
            refreshTokenExpiredTime: AppSettings.value("qml/auth/", "refreshTokenExpiredTime", "")
        }
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
        return !!d.acccessToken;
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

        property string refreshToken
        property string refreshTokenExpiredTime
        property string acccessToken
        property string acccessTokenExpiredTime

        property bool rememberToken: false


        // UNDONE remove this
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

        property bool isPromoActionActive: false

        property bool anotherComputer: false
    }

    ExtendedListModel {
        id: serviceSubscriptions

        idProperty: "serviceId"
    }

    Connections {
        target: App.mainWindowInstance()
        onNavigate: SignalBus.navigate(page, '');


        onAuthorizationError: {
            var errorJwt = Authorization.decodeJwt(accessToken);
            if (!errorJwt
                || !errorJwt.hasOwnProperty('payload')
                || !errorJwt.payload.hasOwnProperty('id')) {
                return;
            }

            if (d.userId != errorJwt.payload.id) {
                // INFO unknown credential
                return;
            }

            var oldJwt = {
                value: accessToken,
                exp: acccessTokenExpiredTime
            }

            if (root.isAccessTokenValid()) {
                App.updateAuthCredential(
                    oldJwt.value,
                    oldJwt.exp,
                    d.acccessToken,
                    d.acccessTokenExpiredTime);
                return;
            }

            var refreshCb = function() {
                App.updateAuthCredential(
                    oldJwt.value,
                    oldJwt.exp,
                    d.acccessToken,
                    d.acccessTokenExpiredTime);

                SignalBus.disconnect.connect(refreshCb);
            }

            SignalBus.authTokenChanged.connect(refreshCb);
            root.refreshTokens();
        }
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
            root.saveCreadential();
        }

        //onProfileUpdated: refreshUserInfo();

        onAnotherComputerChanged: {
            d.anotherComputer = value;
        }

        onAuthTokenExpired: {
            root.refreshTokens();
        }
    }

//    Timer {
//        id: premiumDurationTimer

//        interval: 60000

//        triggeredOnStart: false
//        repeat: true
//        onTriggered: {
//            var duration = d.premiumDuration - 60;
//            if (duration <= 0) {
//                if(d.premiumDuration > 0) {
//                    premiumExpiredTimer.start();
//                }
//                d.premiumDuration = 0;
//                d.isPremium = false;
//                root.refreshPremium();
//            } else {
//                d.premiumDuration = duration;
//            }
//        }
//    }

//    Timer {
//        id: premiumExpiredTimer

//        interval: premiumExpiredNotificationTimeout
//        onTriggered: SignalBus.premiumExpired();
//    }

//    Timer {
//        id: balanceTimer

//        property int tickCount: 0

//        interval: 60000
//        triggeredOnStart: true
//        repeat: true

//        onTriggered: {
//            var localTick = balanceTimer.tickCount + 1;
//            if ((App.isWindowVisible() && localTick >= 2) || localTick >= 5) {
//                balanceTimer.tickCount = 0;
//                refreshBalance();
//            } else {
//                balanceTimer.tickCount++;
//            }
//        }
//    }
}
