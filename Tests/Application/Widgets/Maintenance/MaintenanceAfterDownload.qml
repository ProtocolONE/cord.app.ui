/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 2.4
import GameNet.Core 1.0
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import Application.Core 1.0

Rectangle {
    width: 800
    height: 800
    color: '#5a5a5a'

    Component.onCompleted: {
        RestApi.Games.getMaintenance = function(callback) {
            callback({"schedule" :
                         {"300012010000000000":
                             {"id":"300012010000000000",
                                 "startTime": (+new Date() - 1) / 1000,
                                 "endTime": (+new Date() + 8000) / 1000
                          },

                         "300009010000000000":
                             {"id":"300009010000000000",
                                 "startTime": (+new Date() - 1) / 1000,
                                 "endTime": (+new Date() + 28000) / 1000
                          }
                     }});
        };

        App.activateGameByServiceId("300012010000000000");
    }

    WidgetManager {
        id: manager

        Component.onCompleted: {
            manager.registerWidget('Application.Widgets.Maintenance');
            manager.init();
        }
    }

    ListView {
        id: mainContainer

        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }

        model: ListModel {}
        delegate:  WidgetContainer {
            widget: model.widgetName
        }
    }

    ListView {
        id: mainContainer2

        anchors {
            left: parent.left
            top: parent.top
            margins: 10
            topMargin: 170
        }

        model: ListModel {}
        delegate:  WidgetContainer {
            widget: model.widgetName
            view: model.widgetView
        }
    }

    Row {
        x: 10
        y: 300
        spacing: 20

        Button {
            width: 200
            height: 30

            text: "Start 92 (CA)"
            onClicked: {
                App.activateGameByServiceId("300009010000000000");
                mainWindow.downloaderFinished("300009010000000000");
            }
        }

        Button {
            width: 200
            height: 30

            text: "Start Reborn"
            onClicked: {
                App.activateGameByServiceId("300012010000000000");
                mainWindow.downloaderFinished("300012010000000000");
            }
        }
    }

    Item {
        id: mainWindow

        signal downloaderFinished(string service);
        signal currentGameChanged(string service);
    }

    Connections {
        target: mainWindow

        onDownloaderFinished: {
            var game = App.currentGame();
            if (service == game.serviceId && game.maintenance) {
                mainContainer.model.clear();
                mainContainer.model.insert(0, {widgetName: 'Maintenance'});

                mainContainer2.model.clear();
                mainContainer2.model.insert(0, {widgetName: 'Maintenance', widgetView: 'MaintenanceLightView'});
            }
        }
    }

    Connections {
        target: SignalBus

        onGameMaintenanceEnd: {
            console.log('onGameMaintenanceEnd', serviceId);
            var game = App.currentGame();
            if (serviceId === game.serviceId) {
                mainContainer.model.remove(0);
                mainContainer2.model.remove(0);
            }
        }
    }
}
