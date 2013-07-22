import QtQuick 1.1
import  "../../js/restapi.js" as RestApi

Item {
    id: root

    property string newsXml

    function reloadNews() {
        RestApi.Wall.getNewsXml(function(news) {
            if (news) {
                newsXml = news;
            }

        }, function(){});
    }

    Component.onCompleted: refreshNewsTimer.start()

    Timer {
        id: refreshNewsTimer

        //INFO from 15 to 60 minutes
        interval: 900000 + Math.floor(Math.random() * 2700000)
        running: false
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            console.log('Reloading news block');
            root.reloadNews();
        }
    }
}
