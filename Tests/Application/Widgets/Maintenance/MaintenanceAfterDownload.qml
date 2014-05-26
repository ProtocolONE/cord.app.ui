/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2014, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1
import GameNet.Components.Widgets 1.0
import GameNet.Controls 1.0

import "../../../../js/Core.js" as Core
import "../../../../js/restapi.js" as RestApi

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

        Core.activateGameByServiceId("300012010000000000");
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

    Row {
        x: 10
        y: 200
        spacing: 20

        Button {
            width: 200
            height: 30

            text: "Start 92 (CA)"
            onClicked: {
                Core.activateGameByServiceId("300009010000000000");
                mainWindow.downloaderFinished("300009010000000000");
            }
        }

        Button {
            width: 200
            height: 30

            text: "Start Reborn"
            onClicked: {
                Core.activateGameByServiceId("300012010000000000");
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
            var game = Core.currentGame();
            if (service == game.serviceId && game.maintenance) {
                mainContainer.model.clear();
                mainContainer.model.insert(0, {widgetName: 'Maintenance'});
            }
        }
    }

    Connections {
        target: Core.signalBus()

        onGameMaintenanceEnd: {
            console.log('onGameMaintenanceEnd', index);
            var game = Core.currentGame();
            if (index === game.serviceId) {
                mainContainer.model.remove(0);
            }
        }
    }
}
