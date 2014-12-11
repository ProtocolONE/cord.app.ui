.pragma library

var _proxyServiceHandleQml;

if (!_proxyServiceHandleQml) {
    var component = Qt.createComponent("./ServiceHandleModel.qml");
    _proxyServiceHandleQml = component.createObject(null);
}

function serviceHandleModel() {
    return _proxyServiceHandleQml;
}
