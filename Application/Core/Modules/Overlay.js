.pragma library

var _overlayEnabled = false,
    _overlayChatVisible = false;

function setOverlayEnabled(overlayEnabled) {
    _overlayEnabled = overlayEnabled;
}

function isOverlayEnabled() {
    return _overlayEnabled;
}

function setOverlayChatVisible(isVisible) {
    _overlayChatVisible = isVisible;
}

function overlayChatVisible() {
    return _overlayChatVisible;
}