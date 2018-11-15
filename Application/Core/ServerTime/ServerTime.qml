pragma Singleton

import QtQuick 2.4
import ProtocolOne.Core 1.0

Item {
    id: root

    property int timeDiff: 0 // in sec
    function refreshServerTime() {
        root.timeDiff = 0;
        RestApi.Misc.getTime(function (code, response) {
            if (!RestApi.ErrorEx.isSuccess(code)) {
                console.log('RestApi.Misc.getTime error', code);
                return;
            }

            var localTime = +Date.now();
            var serverTime = +(new Date(response.atom));

            root.timeDiff = (serverTime - localTime) / 1000;
        })
    }

    function correctTime(serverTimeInSec) {
        return serverTimeInSec - root.timeDiff;
    }

    function serverAtomTimeToLocalTimestamp(serverAtomTime) {
        var serverTime = +(new Date(serverAtomTime)) / 1000;
        return correctTime(serverTime);
    }
}
