import QtQuick 2.4
import ProtocolOne.Core 1.0
import ProtocolOne.Components.Widgets 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import "../"

Rectangle {
    width: 800
    height: 800
    color: '#5a5a5a'

    property variant currentGame: App.currentGame()

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
                                 "startTime": (+new Date() - 16400000) / 1000,
                                 "endTime": (+new Date() + 16400000) / 1000
                          }
                     }});
        };
    }

    onCurrentGameChanged: {
        mainContainer.model.clear()
        mainContainer2.model.clear()

        if (!currentGame) {
            return;
        }

        mainContainer.model.append({widgetName: 'Maintenance', widgetView: 'MaintenanceView', serviceId: currentGame.serviceId });
        mainContainer2.model.append({widgetName: 'Maintenance', widgetView: 'MaintenanceLightView', serviceId: currentGame.serviceId });
    }

    RequestServices {
        onReady: {
            WidgetManager.registerWidget('Application.Widgets.Maintenance');
            WidgetManager.init();

            App.activateGameByServiceId("300012010000000000");
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
            view: model.widgetView
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

            text: "Activate 92 (CA)"
            onClicked: {
                App.activateGameByServiceId("300009010000000000");
            }
        }

        Button {
            width: 200
            height: 30

            text: "Activate Reborn"
            onClicked: {
                App.activateGameByServiceId("300012010000000000");
            }
        }
    }
}
