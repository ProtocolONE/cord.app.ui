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

var _userId = undefined,
    _appKey = undefined,
    _cookie = undefined;

function setCredential(userId, appKey, cookie) {
    _userId = userId;
    _appKey = appKey;
    _cookie = cookie;
};

function reset() {
    setCredential(undefined, undefined, undefined);
}

function userId() {
    return _userId;
}

function appKey() {
    return _appKey;
}

function cookie() {
    return _cookie;
}

function getUrlWithCookieAuth(url)
{
    return _cookie ? 'https://gnlogin.ru/?auth=' + _cookie + '&rp=' + encodeURIComponent(url) :url;
}
