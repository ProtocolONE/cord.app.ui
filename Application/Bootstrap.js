.pragma library

var _bootstrapComponent,
    _bootstrapInstance;

if (!_bootstrapComponent) {
    _bootstrapComponent = Qt.createComponent('./Bootstrap.qml');
    if (_bootstrapComponent.status == 1) {
        _bootstrapInstance = _bootstrapComponent.createObject(null);
    } else {
        console.log('Can\'t create component Core/Bootstrap.qml');
    }
}
