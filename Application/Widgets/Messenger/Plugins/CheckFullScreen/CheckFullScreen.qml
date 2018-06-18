pragma Singleton

import QtQuick 2.4
import Tulip 1.0

Item {
    id: root

    function isFullScreen() {

        var content, obj = {};
        var settingsPath = StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
            + '/Black Desert/GameOption.txt'

        if (!FileSystem.exists(settingsPath)) {
            return true;
        }

        try {
            content = FileSystem.readFile(settingsPath);
        } catch (e) {
            return true;
        }

        content.trim().split("\n")
            .map(function(e){
                return e.split("=");
            }).forEach(function(e){
                var key = e[0].toString(),
                    value = e[1];

                obj[key.trim()] = value.trim();
            });

        return obj.windowed === '0';
    }
}
