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
    if (_userComponentInstance.status == 1) {
        _userComponentInstance = _userComponent.createObject(null);
    } else {
        console.log('Can\'t create component Core/User.qml');
    }
}

function getBalance() {
    return _userComponentInstance.balance;
}

function nickname() {
    return _userComponentInstance.nickname;
}

function nametech() {
    return _userComponentInstance.nametech;
}

function level() {
    return _userComponentInstance.level;
}

function avatarLarge() {
    return _userComponentInstance.avatarLarge;
}

function avatarMedium() {
    return _userComponentInstance.avatarMedium;
}

function avatarSmall() {
    return _userComponentInstance.avatarSmall;
}

function isGuest() {
    return _userComponentInstance.guest;
}
