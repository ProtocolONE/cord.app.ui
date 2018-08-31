import QtQuick 2.4
import Application.Blocks 1.0
import ProtocolOne.Controls 1.0

import Application.Core 1.0
import "../Widgets"

Rectangle {
    id: root

    width: 1000
    height: 600
    color: "black"

    property string serviceId: '300012010000000000'

    Rectangle {
        anchors.fill: block
        color: "yellow"
        opacity: 0.1
    }

    GameInstallBlock {
        id: block
        anchors.centerIn: parent
    }

    Column {
        spacing: 5
        x: 5
        y: 5

        Button {
            width: 200
            height: 30
            text: "Runnable"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.isRunnable = !item.isRunnable;
            }
        }


        Button {
            width: 200
            height: 30
            text: "AllreadyDownloaded"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.allreadyDownloaded = !item.allreadyDownloaded;
            }
        }

        Button {
            width: 200
            height: 30
            text: "Installed"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.isInstalled = !item.isInstalled;
            }
        }



        Button {
            width: 100
            height: 30
            text: "Normal"
            onClicked: {
                var item = App.serviceItemByServiceId(root.serviceId);
                item.status = "Normal";
            }
        }

        Button {
            width: 100
            height: 30
            text: "Downloading"
            onClicked: {
                var item = App.serviceItemByServiceId(root.serviceId);
                item.status = "Downloading";
                item.statusText = qsTr("Загрузка игры 1956,35 из 3347,21");
                SignalBus.progressChanged(item);
            }
        }
        Button {
            width: 100
            height: 30
            text: "Paused"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.status = "Paused";
                  item.statusText = qsTr("Загрузка игры 0,35 из 3347,21");
            }
        }
        Button {
            width: 100
            height: 30
            text: "Error"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.status = "Error";
                  item.statusText = "Текст ошибки";
            }
        }
        Button {
            width: 100
            height: 30
            text: "Starting"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.status = "Starting";
                  item.statusText = "Подготовка к запуску";
                  SignalBus.serviceStarted(item);

                  App.serviceStarted(serviceId) // fail
                  //App.runningService[serviceId] = 1;
            }
        }
        Button {
            width: 100
            height: 30
            text: "Started"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.status = "Started";
                  item.statusText = "";
            }
        }
        Button {
            width: 100
            height: 30
            text: "Finished"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.status = "Finished";
                  item.statusText = "";
            }
        }
        Button {
            width: 100
            height: 30
            text: "Uninstalling"
            onClicked: {
                  var item = App.serviceItemByServiceId(root.serviceId);
                  item.status = "Uninstalling";
                  item.statusText = "Удаление игры 5%";
            }
        }
    }

    RequestServices {
        onReady: {
            App.downloadButtonStart = function(serviceId) {
                console.log('Mock call downloadButtonStart');
            };
            App.activateGameByServiceId(root.serviceId);
        }
    }
}
