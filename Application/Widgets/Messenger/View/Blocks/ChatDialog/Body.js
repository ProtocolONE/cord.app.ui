.pragma library

var _scroll = {};

function resetSavedScroll()
{
    _scroll = {};
}

function hasSavedScroll(jid) {
    return !!_scroll[jid];
}

function saveScroll(jid, index, mode) {
    _scroll[jid] = [index, mode];
};

function scrollToSaved(scrollObject, jid) {
    scrollObject.positionViewAtIndex(_scroll[jid][0], _scroll[jid][1])
};
