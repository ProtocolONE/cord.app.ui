import QtQuick 2.4
import ProtocolOne.Controls 1.0
import ProtocolOne.Core 1.0

import Application.Core 1.0

Item {
    id: root

    signal finished();

    property string userId
    property string appKey
    property string cookie
    property bool anotherComputer

    property string refreshToken
    property  string refreshTokenExpireTime

    property string accessToken
    property string accessTokenExpireTime

    function requestServices() {
        retryTimer.count += 1;

        RestApi.Core.setUserId(userId);
        RestApi.Core.setAppKey(appKey);

        RestApi.App.getGrid(function(code, result) {
            if (!RestApi.ErrorEx.isSuccess(code)) {
                console.log('Get services grid error');
                retryTimer.start();
                return;
            }

            var grid = result.gridItems.map(function(e){
                return {
                    serviceId: e.game.id,
                    col: e.col,
                    row: e.row,
                    width: e.width,
                    height: e.height,
                    image: e.image || ''
                }
            });

            App.setServiceGrid(grid);
            root.finished();
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
