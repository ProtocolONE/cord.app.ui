.pragma library

var _proxyQml
    , _defaultNamespace = 'qGNA/settings/';

if (!_proxyQml) {
    var component = Qt.createComponent("Settings.qml");
    _proxyQml = component.createObject(null);
}

function isAppSettingsEnabled(path, key, defaultValue) {
    return (1 == _proxyQml.value(_defaultNamespace + path, key, defaultValue|0));
}

function appSettingsValue(path, key, defaultValue) {
    return  _proxyQml.value(_defaultNamespace + path, key, defaultValue|0);
}

function setAppSettingsValue(path, key, defaultValue) {
    return _proxyQml.setValue(_defaultNamespace + path, key, defaultValue);
}

function settingsValue(path, key, defaultValue) {
    return  _proxyQml.value(path, key, defaultValue);
}

function setSettingsValue(path, key, defaultValue)
{
    return _proxyQml.setValue(path, key, defaultValue);
}

function isSettingsEnabled(path, key, defaultValue) {
    return (1 == _proxyQml.value(path, key, defaultValue|0));
}
