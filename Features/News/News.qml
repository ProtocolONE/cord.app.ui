import QtQuick 1.1
import 'News.js' as News
import  "../../js/restapi.js" as RestApi

Item {
    id: root

    property string newsXml
    property bool timerReload: false

    signal newsObtained();

    function reloadNews() {
        RestApi.Wall.getNewsXml(function(news) {
            if (news) {
                newsXml = news;
                newsObtained();
            }

        }, function(){});
    }

    Component.onCompleted: {
            News.setNews(root);
            reloadNews();
    }

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
