var _modelComponent = null,
    _modelInstance = null,
    _jabber = null;

function init(jabber) {
    if (_jabber !== null) {
        throw new Error('[Logger] Already initialized');
    }

    console.log('[Logger] Init module connections');

    _modelComponent = Qt.createComponent('./Logger.qml');
    if (_modelComponent.status !== 1) {
         throw new Error('Can\'t create Logger.qml'+ _modelComponent.errorString());
    }
    _modelInstance = _modelComponent.createObject(null);

    _jabber = jabber;

    jabber.logger.message.connect(_modelInstance.logMessage);
    jabber.logger.enabled = true;
}
