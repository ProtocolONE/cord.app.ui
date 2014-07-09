/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/

.pragma library

var _startedGameCount = 0;

// Следующая переменная используется в Announcements.qml
var announceList = {};

function onGameStarted() {
    _startedGameCount++;
}

function onGameClosed() {
    _startedGameCount--;
}

function isAnyGameStarted() {
    return _startedGameCount > 0;
}

