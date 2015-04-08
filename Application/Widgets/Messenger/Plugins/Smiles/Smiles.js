.pragma library

var _modelComponent = null,
    _modelInstance = null,
    _jabber = null;

function init(jabber) {
    if (_jabber !== null) {
        throw new Error('[Smiles] Already initialized');
    }

    console.log('[Smiles] Init plugin');

    _modelComponent = Qt.createComponent('./Smiles.qml');
    if (_modelComponent.status !== 1) {
         throw new Error('Can\'t create Smiles.qml'+ _modelComponent.errorString());
    }
    _modelInstance = _modelComponent.createObject(null);
    _jabber = jabber;

    jabber.connected.connect(function() {
        console.log('[Smiles] On connected load recent smiles');
        _modelInstance.loadRecentSmiles(jabber.myJid)
    });

    jabber.messageSending.connect(function(jid, message) {
        console.log('[Smiles] On messageSending process smiles');
        _modelInstance.processSmiles(jabber.myJid, message.body)
    });
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
