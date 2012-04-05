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

