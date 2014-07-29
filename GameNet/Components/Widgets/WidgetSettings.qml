import QtQuick 1.1
import Tulip 1.0

QtObject {
    id: root

    property string namespace

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
        var fields = root.enumerateProperties();
        fields.forEach(function(field) {
            root.setValue(field, root[field]);
            root.propertySaved(field, root[field]);
        });
    }

    function load() {
        var fields = root.enumerateProperties();
        fields.forEach(function(field) {
            var value = root.value(field, undefined);
            if (value !== undefined) {
                root[field] = value;
            }
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

    Component.onCompleted: load();
}
