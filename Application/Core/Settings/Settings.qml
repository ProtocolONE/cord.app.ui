pragma Singleton
import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    property string defaultNamespace: "Launcher/settings/"

    function value(path, key, value) {
       return Settings.value(path, key, value);
    }

    function setValue(path, key, value) {
        if (!path || !key) {
            console.log('Settings failed', path, key);
        }

        return Settings.setValue(path, key, value);
    }

    function remove(path, key) {
        Settings.remove(path, key);
    }

    function isSettingsEnabled(path, key, defaultValue) {
        return (1 == root.value(path, key, defaultValue|0));
    }

    function isAppSettingsEnabled(path, key, defaultValue) {
        return (1 == root.value(root.defaultNamespace + path, key, defaultValue|0));
    }

    function appSettingsValue(path, key, defaultValue) {
        return root.value(root.defaultNamespace + path, key, defaultValue|0);
    }

    function setAppSettingsValue(path, key, defaultValue) {
        return root.setValue(root.defaultNamespace + path, key, defaultValue);
    }

    function hostSettingsValue(path, key, defaultValue) {
        return Settings.valueHost(root.defaultNamespace + path, key, defaultValue|0);
    }

    function setRemoteValue(path, key, value) {
        if (!path || !key) {
            console.log('Settings failed', path, key);
        }

        wrapper.item.setValue(root.defaultNamespace + path, key, value);
    }

    function remoteVaule(path, key, defaultValue) {
        return wrapper.item.value(root.defaultNamespace + path, key, defaultValue|0);
    }

    Loader {
        id: wrapper

        source: "./RemoteSettingsPrivare.qml"
    }    
}
