import QtQuick 2.4
import Tulip 1.0

QtObject {
    id: root

    property string namespace
    property variant autoSave: []

    property variant __properties: []
    property variant __supportedTypes: ['boolean', 'string', 'number']
    property string __defaultNamespace: 'qml/widgets/'

    signal propertySaved(string field, variant value);

    function enumerateProperties() {
        var props = []
            , field
            , skipField;
        for (field in root) {
            skipField = !root.hasOwnProperty(field)
                || field === 'namespace'
                || field === 'objectName'
                || 0 === field.indexOf('__')
                || -1 === __supportedTypes.indexOf(typeof root[field]);

            if (skipField) {
                continue;
            }

            props.push(field);
        }

        return props;
    }

    function value(key, value) {
        return Settings.value(__defaultNamespace + root.namespace + '/settings/', key, value);
    }

    function setValue(key, value)
    {
        return Settings.setValue(__defaultNamespace + root.namespace + '/settings/', key, value);
    }

    function save() {
        __properties.filter(function(field) {
            return -1 === autoSave.indexOf(field);
        }).forEach(function(field) {
            root.setValue(field, root[field]);
            root.propertySaved(field, root[field]);
        });
    }

    function load() {
        __properties.forEach(function(field) {
            var value = root.value(field, undefined);
            if (value !== undefined) {
                switch (typeof root[field]) {
                case 'boolean':
                    value = (value === "true" || value === 1 || value === true);
                    break;
                case 'number':
                    value = Number(value);
                    break;
                }
                root[field] = value;
            }
        });
    }

    function connectToAutoLoad() {
        autoSave.filter(function(field) {
            return -1 !== __properties.indexOf(field);
        }).forEach(function(field) {
            var changeSignal = field + 'Changed';
            if (!root.hasOwnProperty(changeSignal)) {
                return;
            }

            root[changeSignal].connect(function() {
                root.setValue(field, root[field]);
                root.propertySaved(field, root[field]);
            });
        });
    }

    function getOption(name) {
        var value = null;
        try {
            eval('value = ' + name + ';');
        } catch (e) {
        }
        return value;
    }

    function setOption(name, value) {
        try {
            eval('' + name + '=' + value +';');
        } catch (e) {
            return false;
        }
        return true;
    }

    Component.onCompleted: {
        __properties = enumerateProperties();
        load();
        connectToAutoLoad();
    }
}
