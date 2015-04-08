.pragma library
/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

var _userComponent,
        _userComponentInstance;

if (!_userComponent) {
    _userComponent = Qt.createComponent('./User.qml');
    if (_userComponent.status == 1) {
        _userComponentInstance = _userComponent.createObject(null);
    } else {
        console.log('Can\'t create component Core/User.qml, reason: ' + _userComponent.errorString());
    }
}

function getInstance() {
    return _userComponentInstance;
}

function userId() {
    return  _userComponentInstance.userId;
}

function appKey() {
    return  _userComponentInstance.appKey;
}

function cookie() {
    return  _userComponentInstance.cookie;
}

function isAuthorized() {
    return !!userId() && !!appKey() && !!cookie();
}

function isPremium() {
    return  _userComponentInstance.isPremium;
}

function isLoginConfirmed() {
    return _userComponentInstance.isLoginConfirmed;
}

function getPremiumDuration() {
    return _userComponentInstance.premiumDuration;
}

function getBalance() {
    return _userComponentInstance.balance;
}

function setNickname(value) {
    _userComponentInstance.nickname = value;
}

function getNickname() {
    return _userComponentInstance.nickname;
}

function setTechname(value) {
    _userComponentInstance.nametech = value;
}

function getTechName() {
    return _userComponentInstance.nametech;
}

function getLevel() {
    return _userComponentInstance.level;
}

function getAvatarLarge() {
    return _userComponentInstance.avatarLarge;
}

function getAvatarMedium() {
    return _userComponentInstance.avatarMedium;
}

function getAvatarSmall() {
    return _userComponentInstance.avatarSmall;
}

function isGuest() {
    return _userComponentInstance.guest;
}

function refreshUserInfo() {
    _userComponentInstance.refreshUserInfo();
}

function refreshPremium() {
    _userComponentInstance.refreshPremium();
}

function refreshBalance() {
    _userComponentInstance.refreshBalance();
}

function getUrlWithCookieAuth(url) {
    return _userComponentInstance.cookie
            ? 'https://gnlogin.ru/?auth=' + _userComponentInstance.cookie + '&rp=' + encodeURIComponent(url)
            : url;
}

function setSecondCredential(userId, appKey, cookie) {
    _userComponentInstance.secondUserId = userId;
    _userComponentInstance.secondAppKey = appKey;
    _userComponentInstance.secondCookie = cookie;
};

function resetSecond() {
    setSecondCredential('', '', '');
    _userComponentInstance.secondNickname = "";
}

function secondUserId() {
    return  _userComponentInstance.secondUserId;
}

function secondAppKey() {
    return  _userComponentInstance.secondAppKey;
}

function secondCookie() {
    return  _userComponentInstance.secondCookie;
}

function getSecondNickname() {
    return _userComponentInstance.secondNickname;
}

function isSecondAuthorized() {
    return !!secondUserId() && !!secondAppKey() && !!secondCookie();
}

function isNicknameValid() {
    return getNickname().indexOf('@') == -1;
}
