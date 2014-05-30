.pragma library
/****************************************************************************
 ** This file is a part of Syncopate Limited GameNet Application or it parts.
 **
 ** Copyright (©) 2011 - 2012, Syncopate Limited and/or affiliates.
 ** All rights reserved.
 **
 ** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 ** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 ****************************************************************************/

var _userInfoInstance,
    _userInfoComponent;

if (!_userInfoComponent) {
    _userInfoComponent = Qt.createComponent('./UserInfoPrivate.qml');
    if (_userInfoComponent.status == 1) {
        _userInfoInstance = _userInfoComponent.createObject(null);
    } else {
        console.log('Can\'t create component UserInfoPrivate.qml, reason: ' + _userInfoComponent.errorString());
    }
}

function setCredential(userId, appKey, cookie) {
    _userInfoInstance.userId = userId;
    _userInfoInstance.appKey = appKey;
    _userInfoInstance.cookie = cookie;
};

function reset() {
    setCredential('', '', '');
}

function setUserInfo(userInfo) {
    _userInfoInstance.nickname = userInfo.nickname;
    _userInfoInstance.nametech = userInfo.nametech;
    _userInfoInstance.avatarLarge = userInfo.avatarLarge;
    _userInfoInstance.avatarMedium = userInfo.avatarMedium;
    _userInfoInstance.avatarSmall = userInfo.avatarSmall;
    _userInfoInstance.guest = (userInfo.guest == 1);
}

function instance() {
    return _userInfoInstance;
}

function resetUserInfo() {
    var userInfo = {
        nickname: "",
        nametech: "",
        avatarLarge: "",
        avatarMedium: "",
        avatarSmall: "",
        guest: 0
    };

    setUserInfo(userInfo);
    setIsPremium(false);
    setPremiumDuration(0);
}

function userId() {
    return _userInfoInstance.userId;
}

function appKey() {
    return _userInfoInstance.appKey;
}

function cookie() {
    return _userInfoInstance.cookie;
}

function isAuthorized() {
    return _userInfoInstance.userId !== '' && _userInfoInstance.appKey !== '';
}

function isGuest() {
    return _userInfoInstance.guest;
}

function getUrlWithCookieAuth(url) {
    return _userInfoInstance.cookie
            ? 'https://gnlogin.ru/?auth=' + _userInfoInstance.cookie + '&rp=' + encodeURIComponent(url)
            : url;
}

function isPremium() {
    return _userInfoInstance.isPremium;
}

function setIsPremium(value) {
    _userInfoInstance.isPremium = value;
}

function premiumDuration() {
    return _userInfoInstance.premiumDuration;
}

function setPremiumDuration(value) {
    _userInfoInstance.premiumDuration = value;
}

function refreshPremium() {
    _userInfoInstance.refreshPremium();
}

function refreshBalance() {
    _userInfoInstance.refreshBalance();
}

function balance() {
    return _userInfoInstance.balance;
}

function authDone(userId, appKey, cookie) {
    _userInfoInstance.auth(userId, appKey, cookie);
}

function logoutDone() {
    _userInfoInstance.logoutDone();
}

