import QtQuick 1.1
import GameNet.Controls 1.0
import GameNet.Components.Widgets 1.0

import "../../../Application/Core/App.js" as App
import "../../../Application/Core/restapi.js" as RestApi

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
            App.servicesGrid = result;
            root.finished();
        }, function(result) {
            console.log('Get services grid error');
            retryTimer.start();
        });
    }

    Component.onCompleted: {
        RestApi.Core.setUserId('400001000000065690');
        RestApi.Core.setAppKey('cd34fe488b93d254243fa2754e86df8ffbe382b9');

        root.requestServices();
    }

    function finished() {
        allWidget.force('AllGames','AllGamesView');
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.AllGames');
            manager.init();
        }
    }

    WidgetContainer {
        id: allWidget
        visible: true
        anchors.fill: parent
    }
}
