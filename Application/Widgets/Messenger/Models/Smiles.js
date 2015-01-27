.pragma library

var _modelComponent,
    _modelInstance;

function init() {
    if (!_modelComponent) {
        _modelComponent = Qt.createComponent('./Smiles.qml');
        if (_modelComponent.status === 1) {
            _modelInstance = _modelComponent.createObject(null);
        } else {
            console.log('Can\'t create Smiles.qml', _modelComponent.errorString());
        }
    }
}

function processSmiles(jid, body) {
    _modelInstance.processSmiles(jid, body);
}

function loadRecentSmiles(jid) {
    _modelInstance.loadRecentSmiles(jid);
}

function mostUsedSmilesMap() {
    return _modelInstance.mostUsedSmilesMap();
}

function recentSmilesList() {
    return _modelInstance.recentSmilesList();
}

function sortedRecentSmiles() {
    return _modelInstance.sortedRecentSmiles();
}
