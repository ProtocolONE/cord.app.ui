import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles
import "../../Core/restapi.js" as RestApi

Item {
    id: root

    signal finished();

    property string userId
    property string appKey
    property string cookie

    function requestServices() {
        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        RestApi.Service.getGrid(function(result) {
            App.servicesGrid = result;
            root.finished();
        }, function(result) {
            console.log('Get services grid error');
            retryTimer.start();
        });
    }

    AnimatedImage {
        anchors.centerIn: parent
        source: installPath + "/Assets/Images/Auth/wait.gif"
    }

    Timer {
        id: retryTimer

        property int count: 0

        function getInterval() {
          var timeout = [5, 10, 15, 20, 60];
          var index = (retryTimer.count >= timeout.length) ? (timeout.length - 1) : retryTimer.count;
          retryTimer.count += 1;
          return timeout[index] * 1000;
        }

        interval: getInterval()
        repeat: true
        running: false

        onTriggered: root.requestServices();
    }
}
