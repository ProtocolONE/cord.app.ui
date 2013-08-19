.pragma library

var _root = null

function publicTestInit(item) {
    _root = item;
}

function show() {
    if (!_root) {
        return;
    }

    _root.openMoveUpPage();
}
