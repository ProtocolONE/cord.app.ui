import QtQuick 1.1
import Tulip 1.0

Item {
    function value(path, key, value) {
       return Settings.value(path, key, value);
    }

    function setValue(path, key, value)
    {
        return Settings.setValue(path, key, value);
    }
}
