import QtQuick 1.1
import  "../../js/restapi.js" as RestApi

Item {
    id: root

    property string newsXml
    property bool timerReload: false

    function reloadNews() {
        RestApi.Wall.getNewsXml(function(news) {
            if (news) {
                newsXml = news;
            }

        }, function(){});
    }

    Component.onCompleted: reloadNews()

    Timer {
        //INFO from 15 to 60 minutes
        interval: 900000 + Math.floor(Math.random() * 2700000)
        running: true
        repeat: true
        onTriggered: {
            console.log('Reloading news block');

            root.timerReload = true;
            root.reloadNews();
        }
    }
}
