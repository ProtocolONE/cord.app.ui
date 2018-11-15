pragma Singleton

import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    //property alias val: d.configContent

    QtObject {
        id: d

        property variant configContent: ConfigReader.read(installPath + "Config.yaml");

        function value(name, defval) {
            var result;
            try {
                result = configContent[name];
            } catch(e) {
                result = defval;
            }
            return result;
        }

        function show(obj, tab) {
            for(var key in obj) {
                if (typeof obj[key] === 'object') {
                    console.log(tab + key + ':');
                    show(obj[key], tab + '  ');
                }
                else {
                    console.log(tab + key + ' = ' + obj[key]);
                }
            }
        }
    }

    function show() {
        console.log('Content of the app config file:', installPath + "/Config.yaml");
        d.show(d.configContent, '');
    }

    function value(path, defValue) {

        var names = path.split('\\');
        if (names.length === 0)
            return defValue;

        var result = d.configContent[names.shift()];

        while (names.length > 0) {
            var name = names[0];

            if (typeof result !== 'object')
                break;

            result = result[name];
            names.shift();
        }

        if (names.length > 0)
            return defValue;

        return result;
    }

    function api(path) {
        return (d.configContent["apiUrl"] || "https://gnapi.com:8443/restapi") + (path || "");
    }

    function site(path) {
        return (d.configContent["wwwUrl"] || "https://gamenet.ru") + (path || "");
    }

    function login(path) {
        return (d.configContent["gnloginUrl"] || "https://gnlogin.ru") + (path || "");
    }

    function overrideApi() {
        return d.configContent["overrideApi"] === "true";
    }

    function debugApi() {
        return d.configContent["debugApi"] === "true";
    }

    function saveApi() {
        return d.configContent["saveApi"] === "true";
    }
}
