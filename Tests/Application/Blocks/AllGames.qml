import QtQuick 2.4
import Dev 1.0
import ProtocolOne.Core 1.0
import ProtocolOne.Controls 1.0
import ProtocolOne.Components.Widgets 1.0

import Application.Core 1.0

Item {
    id: root

    width: 800
    height: 550
    visible: true

    function requestServices() {
        RestApi.Service.getUi(function(result) {
            App.fillGamesModel(result);
            root.requestGrid();
        }, function(result) {
            console.log('get services error', result);
        });
    }

    function requestGrid() {
        RestApi.Service.getGrid(function(result) {
            App.setServiceGrid(result);
            root.finished();
        }, function(result) {
            console.log('Get services grid error');
            retryTimer.start();
        });
    }

    Component.onCompleted: {
        User.setCredential('400001000000065690', 'cd34fe488b93d254243fa2754e86df8ffbe382b9', '');
        RestApi.Core.setUserId('400001000000065690');
        RestApi.Core.setAppKey('cd34fe488b93d254243fa2754e86df8ffbe382b9');

        root.requestServices();
    }

    function finished() {
        allWidget.force('AllGames','AllGamesView');
    }

    Item {
        id: manager

        Component.onCompleted: {
            WidgetManager.registerWidget('Application.Widgets.AllGames');
            WidgetManager.init();
        }
    }

    WidgetContainer {
        id: allWidget

        anchors.fill: parent
    }
}
