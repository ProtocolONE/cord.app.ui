.pragma library

var blockedUserMap = {}

function clear() {
    blockedUserMap = {};
}

function block(jid) {
    blockedUserMap[jid] = 1;
}

function unblock(jid) {
    delete blockedUserMap[jid];
}

function isBlocked(jid) {
    return blockedUserMap.hasOwnProperty(jid);
}
