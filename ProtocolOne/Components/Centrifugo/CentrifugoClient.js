
var _sendQueue = []
    , _batchStarted = false;

function isBatchStarted() {
    return _batchStarted;
}

function startBatch() {
    if (_batchStarted) {
        console.log('[Centrifuge] Error. Batch has been started before.');
        return;
    }

    _batchStarted = true;
}

function stopBatch(sendCallback) {
    if (!_batchStarted) {
        return;
    }

    var result = _sendQueue.slice();
    _sendQueue = [];
    _batchStarted = false;

    return result;
}

function addMessage(msg) {
    _sendQueue.push(msg);
}

