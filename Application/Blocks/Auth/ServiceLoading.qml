import QtQuick 2.4
import GameNet.Controls 1.0
import GameNet.Core 1.0

import Application.Core 1.0

Item {
    id: root

    signal finished();

    property string userId
    property string appKey
    property string cookie

    function requestServices() {
        retryTimer.count += 1;


        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        RestApi.Service.getGrid(function(result) {
            App.setServiceGrid(result);
            root.finished();
        }, function(result) {
            console.log('Get services grid error');
            retryTimer.start();
        });
    }

    AnimatedImage {
        anchors.centerIn: parent
        source: installPath + "/Assets/Images/Application/Blocks/Auth/wait.gif"
    }

    Timer {
        id: retryTimer

        property int count: 0

        function getInterval() {
          var timeout = [5, 10, 15, 20, 60];
          var index = (retryTimer.count >= timeout.length) ? (timeout.length - 1) : retryTimer.count;
          return timeout[index] * 1000;
        }

        interval: getInterval()
        repeat: true
        running: false

        onTriggered: root.requestServices();
    }
}
