import QtQuick 1.1
import GameNet.Controls 1.0

import "../../Core/App.js" as App
import "../../Core/Styles.js" as Styles
import "../../Core/restapi.js" as RestApi

Rectangle {
    id: root

    signal finished();

    property string userId
    property string appKey
    property string cookie

    function requestServices() {
        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        RestApi.Service.getUI(function(result) {
            App.servicesUI = result;
            App.fillGamesModel(result.services);
            root.finished();
        }, function(result) {
            console.log('get services error', result.code);
            retryTimer.start();
        });
    }

    color: Styles.style.base

    AnimatedImage {
        anchors.centerIn: parent
        source: installPath + "/Assets/Images/Auth/wait.gif"
    }

    Timer {
        id: retryTimer

        interval: 10000
        repeat: true
        running: false

        onTriggered: root.requestServices();
    }
}
